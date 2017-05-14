# frozen_string_literal: true

module Starter
  require 'starter/builder/template_files'

  class Orms
    class << self
      def build(destination, orm)
        build_initializer(destination, orm)
        build_config(destination, orm)
        # add Rake tasks
      end

      private

      def build_initializer(dest, orm)
        new_dest = File.join(dest, 'config', 'initializer')
        new_file = send("#{orm}_initializer")
        FileUtils.mkdir_p(new_dest) unless Dir.exist?(new_dest)
        FileFoo.write_file(File.join(new_dest, 'database.rb'), new_file)
      end

      def build_config(dest, orm)
        new_dest = File.join(dest, 'config')
        new_file = send("#{orm}_config")
        FileFoo.write_file(File.join(new_dest, 'database.yml'), new_file)
      end

      # templates for ORMs
      def sequel_initializer
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        require 'yaml'

        # load Sequel Configuration
        settings = YAML.load_file('config/db.yml')
        DB = Sequel.connect(settings[ENV['RACK_ENV']])
        FILE
      end

      def sequel_config
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
    end
  end
end
