# frozen_string_literal: true

module Starter
  class Orms
    class << self
      def build(dest, orm)
        load_orm(orm: orm)
        return if @orm.nil?

        if @orm == 'ar' || @orm == 'activerecord'
          # Fixes pooling
          add_middleware(dest, 'ActiveRecord::Rack::ConnectionManagement')
        end

        build_initializer(File.join(dest, 'config', 'initializers'))
        build_config(File.join(dest, 'config'))
        append_to_file(File.join(dest, 'Rakefile'), rakefile)
        append_to_file(File.join(dest, 'Gemfile'), gemfile)
        prepare_for_migrations(File.join(dest, 'db'))
      end

      def config
        <<-FILE.strip_heredoc
        # ActiveRecord Database Configuration
        development:
          adapter: '#{adapter}'
          host: localhost
          port: 27017
          database: "db/development.sqlite3"
          username:
          password:

        test:
          adapter: '#{adapter}'
          host: localhost
          port: 27017
          database: "db/test.sqlite3"
          username:
          password:

        production:
          adapter: '#{adapter}'
          host: localhost
          port: 27017
          database: "db/production.sqlite3"
          username:
          password:
        FILE
      end

      def add_migration(klass_name, resource)
        load_orm
        return if @orm.nil?

        file_name = "#{Time.now.strftime('%Y%m%d%H%m%S')}_Create#{klass_name}.rb"
        migration_dest = File.join(Dir.pwd, 'db', 'migrations', file_name)
        FileFoo.write_file(migration_dest, migration(klass_name, resource))
      end

      def load_orm(orm: ::Starter::Config.read[:orm])
        @orm = orm

        case @orm
        when 'sequel'
          require 'starter/builder/templates/sequel'
          extend(::Starter::Templates::Sequel)
        when 'activerecord', 'ar'
          require 'starter/builder/templates/activerecord'
          extend(::Starter::Templates::ActiveRecord)
        else
          @orm = nil
        end
      end

      private

      def adapter
        @orm == 'sequel' ? 'sqlite' : 'sqlite3'
      end

      def build_initializer(dest)
        FileUtils.mkdir_p(dest)
        FileFoo.write_file(File.join(dest, 'database.rb'), initializer)
      end

      def build_config(dest)
        FileFoo.write_file(File.join(dest, 'database.yml'), config)
      end

      # adds a middleware to config.ru
      def add_middleware(dest, middleware)
        replacement = "use #{middleware}\n\n\\1"
        FileFoo.call!(File.join(dest, 'config.ru')) { |content| content.sub!(/^(run.+)$/, replacement) }
      end

      def append_to_file(file_name, content)
        original = FileFoo.read_file(file_name)
        FileFoo.write_file(file_name, "#{original}\n\n#{content}")
      end

      def prepare_for_migrations(dest)
        migrations = File.join(dest, 'migrations')
        FileUtils.mkdir_p(migrations)
        `touch #{migrations}/.keep`
      end
    end
  end
end
