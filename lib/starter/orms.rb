# frozen_string_literal: true

module Starter
  class Orms
    class << self
      def build(name, dest, orm)
        load_orm(orm: orm)
        return if @orm.nil?

        @name = name

        if @orm == 'ar' || @orm == 'activerecord'
          # Fixes pooling
          add_middleware(dest, 'ActiveRecord::Rack::ConnectionManagement')
          build_standalone_migrations(File.join(dest, '.standalone_migrations'))
        end

        build_initializer(File.join(dest, 'config', 'initializers'))
        build_config(File.join(dest, 'config'))
        append_to_file(File.join(dest, 'Rakefile'), rakefile)
        append_to_file(File.join(dest, 'Gemfile'), gemfile)
        prepare_for_migrations(File.join(dest, 'db'))
      end

      def standalone_migrations
        <<-FILE.strip_heredoc
        config:
          database: config/database.yml
        FILE
      end

      def config
        <<-FILE.strip_heredoc
        # ActiveRecord Database Configuration
        development:
          adapter: #{adapter}
          encoding: unicode
          timeout: 5000
          database: #{@name}_development

        test:
          adapter: #{adapter}
          encoding: unicode
          timeout: 5000
          database: #{@name}_test

        production:
          adapter: #{adapter}
          encoding: unicode
          timeout: 5000
          database: #{@name}_production
        FILE
      end

      def add_migration(klass_name, resource)
        load_orm
        return if @orm.nil?

        file_name = "#{Time.now.strftime('%Y%m%d%H%m%S')}_create_#{klass_name.downcase}.rb"
        migration_dest = File.join(Dir.pwd, 'db', 'migrate', file_name)
        FileOps.write_file(migration_dest, migration(klass_name, resource))
      end

      def load_orm(orm: ::Starter::Config.read[:orm])
        @orm = orm

        case @orm
        when 'sequel'
          extend(Starter::Builder::Sequel)
        when 'activerecord', 'ar'
          extend(Starter::Builder::ActiveRecord)
        else
          @orm = nil
        end
      end

      private

      def adapter
        'postgresql'
      end

      def build_initializer(dest)
        FileUtils.mkdir_p(dest)
        FileOps.write_file(File.join(dest, 'database.rb'), initializer)
      end

      def build_config(dest)
        FileOps.write_file(File.join(dest, 'database.yml'), config)
      end

      def build_standalone_migrations(dest)
        FileOps.write_file(dest, standalone_migrations)
      end

      # adds a middleware to config.ru
      def add_middleware(dest, middleware)
        replacement = "use #{middleware}\n\n\\1"
        FileOps.call!(File.join(dest, 'config.ru')) { |content| content.sub!(/^(run.+)$/, replacement) }
      end

      def append_to_file(file_name, content)
        original = FileOps.read_file(file_name)
        FileOps.write_file(file_name, "#{original}\n\n#{content}")
      end

      def prepare_for_migrations(dest)
        migrate = File.join(dest, 'migrate')
        FileUtils.mkdir_p(migrate)
        `touch #{migrate}/.keep`
      end
    end
  end
end
