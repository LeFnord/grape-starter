# frozen_string_literal: true

module Starter
  class Orms
    class << self
      def build(dest, orm)
        case orm
        when 'sequel'
          require 'starter/builder/templates/sequel'
          extend(::Starter::Templates::Sequel)
        else
          return
        end

        build_initializer(File.join(dest, 'config', 'initializer'))
        build_config(File.join(dest, 'config'))
        append_to_file(File.join(dest, 'Rakefile'), rakefile)
        append_to_file(File.join(dest, 'Gemfile'), gemfile)
        prepare_for_migrations(File.join(dest, 'db'))
      end

      private

      def build_initializer(new_dest)
        FileUtils.mkdir_p(new_dest)
        FileFoo.write_file(File.join(new_dest, 'database.rb'), initializer)
      end

      def build_config(new_dest)
        FileFoo.write_file(File.join(new_dest, 'database.yml'), config)
      end

      def append_to_file(file_name, content)
        original = FileFoo.read_file(file_name)
        FileFoo.write_file(file_name, "#{original}\n\n#{content}")
      end

      def prepare_for_migrations(new_dest)
        migrations = File.join(new_dest, 'migrations')
        FileUtils.mkdir_p(migrations)
        `touch #{migrations}/.keep`
      end
    end
  end
end
