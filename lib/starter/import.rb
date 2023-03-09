# frozen_string_literal: true

module Starter
  class Import
    class << self
      def do_it!(path)
        # your code comes here
        load_spec(path)
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
    end
  end
end
