# frozen_string_literal: true

require 'yaml'

module Starter
  class Config
    class << self
      def read(dest: Dir.getwd)
        @dest = dest
        return {} unless File.exist?(config_file)

        YAML.load_file(config_file)
      end

      def save(dest: Dir.getwd, content: nil)
        @dest = dest
        return if content.nil? || content.empty? || !content.is_a?(Hash)

        existent = File.exist?(config_file) ? YAML.load_file(config_file) : {}
        content = existent.merge(content)
        File.write(config_file, YAML.dump(content))
      end

      def config_file
        File.join(@dest, '.config')
      end
    end
  end
end
