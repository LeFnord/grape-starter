# frozen_string_literal: true
require 'active_support/core_ext/string'

module Starter
  require 'starter/builder/names'
  require 'starter/builder/template_files'
  require 'starter/builder/template_endpoints'

  class Builder
    extend Starter::Names
    extend Template::Files
    extend Template::Endpoints

    class << self
      attr_reader :resource, :set, :force, :entity

      def call!(resource, options = {})
        @resource = resource
        @set = options[:set]
        @force = options[:force]
        @entity = options[:entity]

        self
      end

      def remove!(resource, options = {})
        @resource = resource
        @entity = options[:entity]

        file_list.map { |x| send("#{x}_name") }.each do |file_to_remove|
          begin
            FileUtils.rm file_to_remove
          rescue => error
            $stdout.puts error.to_s
          end
        end

        remove_mount_point
      end

      def save
        created_files = file_list.each_with_object([]) do |new_file, memo|
          memo << send("#{new_file}_name")
          save_file(new_file)
        end

        add_mount_point

        created_files
      end

      def endpoints
        content(endpoint_set).join("\n\n")
      end

      def endpoint_specs
        content(endpoint_set.map { |x| "#{x}_spec" }).join("\n")
      end

      private

      def file_list
        standards = %w(api_file lib_file api_spec lib_spec)

        entity ? standards + ['entity_file'] : standards
      end

      def should_raise?(file)
        raise StandardError, '… resource exists' if File.exist?(file) && !force
      end

      def add_mount_point
        file = read_file(api_base_file_name)
        add_to_base(file)
        write_file(api_base_file_name, file)
      end

      def remove_mount_point
        file = read_file(api_base_file_name)
        remove_from_base(file)
        write_file(api_base_file_name, file)
      end

      def save_file(new_file)
        new_file_name = "#{new_file}_name"
        should_raise?(send(new_file_name))

        write_file(send(new_file_name), send(new_file.strip_heredoc))
      end

      def endpoint_set
        crud_set = singular? ? singular_one : crud
        return crud_set if set.blank?

        crud_set.each_with_object([]) { |x, memo| set.map { |y| memo << x if x.to_s.start_with?(y) } }
      end

      # manipulating API Base file
      # … adding
      def add_to_base(file)
        occurence = file.scan(/(\s+mount.*?\n)/).last.first
        replacement = occurence + mount_point
        file.sub!(occurence, replacement)
      end

      # … removing
      def remove_from_base(file)
        file.sub!(mount_point, '')
      end

      def read_file(file)
        File.read(file)
      end

      def write_file(file, content)
        File.open(file, 'w') { |f| f.write(content) }
      end

      def content(set)
        set.map { |x| send(x) }
      end
    end
  end
end
