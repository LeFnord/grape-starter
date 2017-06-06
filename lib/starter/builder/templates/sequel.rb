# frozen_string_literal: true

module Starter
  module Templates
    module Sequel
      def model_klass
        'Sequel::Model'
      end

      def initializer
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        require 'yaml'

        # load Sequel Configuration
        settings = YAML.load_file('config/database.yml')
        DB = Sequel.connect(settings[ENV['RACK_ENV']])

        # FIXME: maybe remove it later …
        #   see: https://groups.google.com/forum/#!topic/sequel-talk/QIIv5qoltjs
        Sequel::Model.require_valid_table = false
        FILE
      end

      def config
        <<-FILE.strip_heredoc
        # Sequel Database Configuration
        development:
          adapter: 'sqlite'
          host: localhost
          port: 27017
          database: "db/development.sqlite3"
          username:
          password:

        test:
          adapter: 'sqlite'
          host: localhost
          port: 27017
          database: "db/test.sqlite3"
          username:
          password:

        production:
          adapter: 'sqlite'
          host: localhost
          port: 27017
          database: "db/production.sqlite3"
          username:
          password:
        FILE
      end

      def rakefile
        <<-FILE.strip_heredoc
        # Sequel migration tasks
        namespace :db do
          Sequel.extension(:migration)

          desc "Prints current schema version"
          task version: :connect do
            version = if DB.tables.include?(:schema_info)
              DB[:schema_info].first[:version]
            end || 0

            $stdout.print 'Schema Version: '
            $stdout.print version
            $stdout.print "\n"
          end

          desc 'Run all migrations in db/migrations'
          task migrate: :connect do
            Sequel::Migrator.apply(DB, 'db/migrations')
            Rake::Task['db:version'].execute
          end

          desc "Perform rollback to specified target or full rollback as default"
          task :rollback, [:target] => :connect do |t, args|
            args.with_defaults(:target => 0)

            Sequel::Migrator.run(DB, 'db/migrations', :target => args[:target].to_i)
            Rake::Task['db:version'].execute
          end

          desc "Perform migration reset (full rollback and migration)"
          task reset: :connect do
            Sequel::Migrator.run(DB, 'db/migrations', target: 0)
            Sequel::Migrator.run(DB, 'db/migrations')
            Rake::Task['db:version'].execute
          end

          task connect: :environment do
            require './config/initializers/database'
          end
        end
        FILE
      end

      def gemfile
        <<-FILE.strip_heredoc
        # DB stack
        gem 'sequel'
        gem 'sqlite3'
        FILE
      end
    end
  end
end
