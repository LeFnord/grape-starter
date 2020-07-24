# frozen_string_literal: true

module Starter
  module Templates
    module ActiveRecord
      def model_klass
        'ActiveRecord::Base'
      end

      def initializer
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
                   Logger.new(STDOUT)
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
                  ActiveRecord::Base.clear_active_connections!
                end

                return response
              rescue StandardError
                ActiveRecord::Base.clear_active_connections!
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
        require 'standalone_migrations'
        StandaloneMigrations::Tasks.load_tasks
        FILE
      end

      def gemfile
        <<-FILE.strip_heredoc
        # BE stuff
        gem 'standalone_migrations'

        # DB stuff
        gem 'activerecord', '>= 6'
        gem 'pg'
        FILE
      end

      def migration(klass_name, resource)
        <<-FILE.strip_heredoc
        class Create#{klass_name} < ActiveRecord::Migration[6.0]
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
