# frozen_string_literal: true

module Starter
  class Config
    CONFIG_FILE = File.join(Dir.getwd, '.config')
    class << self
      def read
        return {} unless File.exist?(CONFIG_FILE)
        YAML.load_file(CONFIG_FILE)
      end

      def save(dest: Dir.getwd, content: nil)
        return if content.nil? || content.empty? || !content.is_a?(Hash)
        content = read.merge(content)
        File.open(File.join(dest, '.config'), 'w') { |f| f.write(YAML.dump(content)) }
      end
    end
  end
end
