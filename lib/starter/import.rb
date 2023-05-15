# frozen_string_literal: true

require 'json'
require 'yaml'

module Starter
  class Import
    extend Shared::BaseFile

    class << self
      def do_it!(path)
        # your code comes here

        spec = load_spec(path)
        create_files_from(spec)
      end

      def load_spec(path)
        return nil if path.blank?

        spec = case File.extname(path)[1..]
               when 'yaml', 'yml'
                 YAML.load_file(path)
               when 'json'
                 JSON.load_file(path)
               end

        Importer::Specification.new(spec)
      end

      def create_files_from(spec)
        spec.namespaces.each_with_object([]) do |(name_of, paths), memo|
          @naming = Starter::Names.new(name_of)

          #   1. build content for file
          namespace = Starter::Importer::Namespace.new(
            naming: @naming,
            paths: paths,
            components: spec.components
          )
          puts namespace.file

          break if ENV['RACK_ENV'] == 'test'

          #   2. create endpoint file
          FileOps.write_file(@naming.api_file_name, namespace.file)
          memo << @naming.api_file_name

          #   3. add mountpoint
          add_mount_point
        end
      end
    end
  end
end
