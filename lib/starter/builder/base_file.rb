# frozen_string_literal: true

module Starter
  module Builder
    module BaseFile
      # add it in api base
      def add_mount_point
        FileOps.call!(api_base_file_name) { |content| add_to_base(content) }
      end

      # adding mount point to base class
      def add_to_base(file)
        occurence = file.scan(/(\s+mount\s.*?\n)/).last.first
        replacement = occurence + mount_point
        file.sub!(occurence, replacement)
      end

      # removes in api base
      def remove_mount_point
        FileOps.call!(api_base_file_name) { |content| remove_from_base(content) }
      end

      # removes mount point from base class
      def remove_from_base(file)
        file.sub!(mount_point, '')
      end

      # parses out the prefix from base api file
      def base_prefix
        Starter::Config.read[:prefix]
      end

      # parses out the version from base api file
      def base_version
        base_file

        base_file.scan(/version\s+(.+),/).first.first.delete!("'")
      end

      # get api base file as string
      def base_file
        file = File.join(Dir.getwd, 'api', 'base.rb')
        FileOps.read_file(file)
      end
    end
  end
end
