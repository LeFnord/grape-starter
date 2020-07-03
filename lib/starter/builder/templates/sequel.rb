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

        env = ENV['RACK_ENV'] || 'development'

        logger = if %w[development test].include? env
                   log_dir = File.join(Dir.getwd, 'log')
                   log_file = File.join(log_dir, 'db.log')
                   FileUtils.mkdir(log_dir) unless Dir.exist?(log_dir)
                   Logger.new(File.open(log_file, 'a'))
                 else
                   Logger.new($stdout)
                 end

        DB.loggers << logger

        # FIXME: maybe remove it later …
        #   see: https://groups.google.com/forum/#!topic/sequel-talk/QIIv5qoltjs
        Sequel::Model.require_valid_table = false
        Sequel::Model.plugin :force_encoding, 'UTF-8'
        FILE
      end

      def rakefile
        <<-FILE.strip_heredoc
        # Sequel migration tasks
        namespace :db do
          Sequel.extension(:migration)

          desc "Prints current schema version"
          task version: :connect do
            version = DB.tables.include?(:schema_info) ? DB[:schema_info].first[:version] : 0

            $stdout.print 'Schema Version: '
            $stdout.puts version
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
        gem 'pg'
        FILE
      end

      def migration(_klass_name, resource)
        <<-FILE.strip_heredoc
        Sequel.migration do
          change do
            create_table :#{resource} do
              primary_key :id

              DateTime :created_at
              DateTime :updated_at
            end
          end
        end
        FILE
      end
    end
  end
end
