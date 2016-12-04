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

      def remove!(resource)
        @resource = resource

        files_to_remove = file_list.map { |x| send("#{x}_name") }
        FileUtils.rm files_to_remove
      end

      def save
        file_list.each do |new_file|
          save_file(new_file)
        end

        add_moint_point

        file_list.map { |x| send("#{x}_name") }
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

      def save_file(new_file)
        new_file_name = "#{new_file}_name"
        should_raise?(send(new_file_name))

        File.open(send(new_file_name), 'w+') { |file| file.write(send(new_file.strip_heredoc)) }
      end

      def should_raise?(file)
        raise StandardError, '… resource exists' if File.exist?(file) && !force
      end

      def add_moint_point
        file = File.read(api_base_file_name)
        occurence = file.scan(/(\s+mount.*?\n)/).last.first
        replacement = occurence + "    mount Endpoints::#{klass_name}\n"
        file.sub!(occurence, replacement)
        File.open(api_base_file_name, 'w') { |f| f.write(file) }
      end

      def endpoint_set
        crud_set = singular? ? singular_one : crud
        return crud_set if set.blank?

        crud_set.each_with_object([]) { |x, memo| set.map { |y| memo << x if x.to_s.start_with?(y) } }
      end

      def content(set)
        set.map { |x| send(x) }
      end
    end
  end
end
