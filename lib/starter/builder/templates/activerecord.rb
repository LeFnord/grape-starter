# frozen_string_literal: true

module Starter
  module Templates
    module ActiveRecord
      def model_klass
        'ActiveRecord::Base'
      end

      def initializer
        <<-FILE.strip_heredoc
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
              rescue Exception
                ActiveRecord::Base.clear_active_connections!
                raise
              end
            end
          end
        end
        FILE
      end

      def config # TODO: Dry (Same config for Sequel)
        <<-FILE.strip_heredoc
        # ActiveRecord Database Configuration
        development:
          adapter: 'sqlite3'
          host: localhost
          port: 27017
          database: "db/development.sqlite3"
          username:
          password:

        test:
          adapter: 'sqlite3'
          host: localhost
          port: 27017
          database: "db/test.sqlite3"
          username:
          password:

        production:
          adapter: 'sqlite3'
          host: localhost
          port: 27017
          database: "db/production.sqlite3"
          username:
          password:
        FILE
      end

      def rakefile
        <<-FILE.strip_heredoc
        # ActiveRecord DB tasks

        task :load_config do
          config_dir = File.expand_path('../config', __FILE__)
          config_content = File.read(File.join(config_dir, 'database.yml'))

          DatabaseTasks.env = ENV['RACK_ENV'] || 'development'
          DatabaseTasks.db_dir = db_dir
          config = YAML.safe_load(ERB.new(config_content).result)
          DatabaseTasks.database_configuration = config
          DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

          ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
          ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
        end

        # Loads AR tasks like db:create, db:drop etc..
        load 'active_record/railties/databases.rake'
        FILE
      end

      def gemfile
        <<-FILE.strip_heredoc
        # DB stack
        gem 'activerecord', '~> 5.1'
        gem 'sqlite3'
        FILE
      end
    end
  end
end
