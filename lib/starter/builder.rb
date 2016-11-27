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
      attr_reader :resource, :set

      def call!(resource, set = nil)
        @resource = resource
        @set = set

        self
      end

      def save
        %w(api_file lib_file api_spec lib_spec).each do |new_file|
          File.open(send("#{new_file}_name"), 'w+') { |file| file.write(send(new_file.strip_heredoc)) }
        end

        add_moint_point
      end

      def endpoints
        endpoint_object.join("\n\n")
      end

      def endpoint_object
        enpoint_preparation(endpoint_set, 4)
      end

      private

      def endpoint_set
        crud_set = singular? ? singular_one : crud
        return crud_set if set.nil?

        crud_set.each_with_object([]) { |x, memo| set.map { |y| memo << x if x.to_s.start_with?(y) } }
      end

      def add_moint_point
        file = File.read(api_base_file_name)
        occurence = file.scan(/(\s+mount.*?\n)/).last.first
        replacement = occurence + "    mount Endpoints::#{klass_name}\n"
        file.sub!(occurence, replacement)
        File.open(api_base_file_name, 'w') { |f| f.write(file) }
      end

      def enpoint_preparation(set, deep)
        set.map { |x| send(x) }.map { |x| indent(x, deep) }
      end

      def indent(endpoint, deep)
        indentation = ' ' * deep

        endpoint.split("\n").map { |x| x.prepend(indentation) }.join("\n")
      end
    end
  end
end
