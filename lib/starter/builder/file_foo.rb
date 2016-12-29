# frozen_string_literal: true
module Starter
  class FileFoo
    class << self
      # general file stuff
      #
      # … reading and writing content
      def call!(file)
        content = read_file(file)
        yield content
        write_file(file, content)
      end

      # … read
      def read_file(file)
        File.read(file)
      end

      # … write
      def write_file(file, content)
        File.open(file, 'w') { |f| f.write(content) }
      end
    end
  end
end
