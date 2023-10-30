# frozen_string_literal: true

require 'active_record'

module Starter
  module Builder
    module ActiveRecord
      def model_klass
        'ActiveRecord::Base'
      end

      def initializer # rubocop:disable Metrics/MethodLength
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        require 'yaml'
        require 'erb'
        require 'active_record'

        config_content = File.read(File.join('config', 'database.yml'))

        db_conf = YAML.safe_load(ERB.new(config_content).result)
        env = ENV['RACK_ENV'] || 'development'

        ActiveRecord::Base.establish_connection db_conf[env]
        logger = if %w[development test].include? env
                  log_dir = File.join(Dir.getwd, 'log')
                  log_file = File.join(log_dir, 'db.log')
                  FileUtils.mkdir(log_dir) unless Dir.exist?(log_dir)
                  Logger.new(File.open(log_file, 'a'))
                else
                  Logger.new($stdout)
                end

        ActiveRecord::Base.logger = logger

        # Middleware
        module ActiveRecord
          module Rack
            # ActiveRecord >= 5 removes the Pool management
            class ConnectionManagement
              def initialize(app)
                @app = app
              end

              def call(env)
                response = @app.call(env)
                response[2] = ::Rack::BodyProxy.new(response[2]) do
                  ActiveRecord::Base.connection_handler.clear_active_connections!
                end

                return response
              rescue StandardError
                ActiveRecord::Base.connection_handler.clear_active_connections!
                raise
              end
            end
          end
        end
        FILE
      end

      def rakefile
        <<-FILE.strip_heredoc
        # ActiveRecord migration tasks
        require 'active_record'
        include ActiveRecord::Tasks
        config_dir = File.expand_path('../config', __FILE__)
        config_content = File.join(config_dir, 'database.yml')
        DatabaseTasks.env = ENV['RACK_ENV'] || 'development'
        DatabaseTasks.database_configuration = YAML.load_file(config_content)
        DatabaseTasks.db_dir = 'db'
        DatabaseTasks.migrations_paths = File.join('db', 'migrate')

        ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
        ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym

        load 'active_record/railties/databases.rake'
        FILE
      end

      def gemfile
        <<-FILE.strip_heredoc
        # DB stuff
        gem 'activerecord', '>= 6'
        gem 'pg'
        FILE
      end

      def migration(klass_name, resource)
        version = "#{::ActiveRecord::VERSION::MAJOR}.#{::ActiveRecord::VERSION::MINOR}"
        <<-FILE.strip_heredoc
        class Create#{klass_name} < ActiveRecord::Migration[#{version}]
          def change
            create_table :#{resource} do |t|

              t.timestamps
            end
          end
        end
        FILE
      end
    end
  end
end
