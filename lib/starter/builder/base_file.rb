# frozen_string_literal: true
module Starter
  module BaseFile
    # add it in api base
    def add_mount_point
      FileFoo.call!(api_base_file_name) { |content| add_to_base(content) }
    end

    # adding mount point to base class
    def add_to_base(file)
      occurence = file.scan(/(\s+mount\s.*?\n)/).last.first
      replacement = occurence + mount_point
      file.sub!(occurence, replacement)
    end

    # removes in api base
    def remove_mount_point
      FileFoo.call!(api_base_file_name) { |content| remove_from_base(content) }
    end

    # removes mount point form base class
    def remove_from_base(file)
      file.sub!(mount_point, '')
    end

    def base_prefix
      base_file

      base_file.scan(/prefix\s+(:.+)\n/).first.first.delete!(':')
    end

    def base_version
      base_file

      base_file.scan(/version\s+(.+),/).first.first.delete!("'")
    end

    def base_file
      file = File.join(Dir.getwd, 'api', 'base.rb')
      FileFoo.read_file(file)
    end
  end
end
