# frozen_string_literal: false

module Starter
  module Importer
    class Parameter
      class Error < StandardError; end

      attr_accessor :kind, :name, :definition

      def initialize(definition:, components: {})
        @kind = validate_parameters(definition:, components:)
        prepare_attributes(definition:, components:)
      end

      def to_s
        entry = definition['required'] ? 'requires' : 'optional'
        entry << " :#{name}"
        entry << ", type: #{definition['schema']['type'].capitalize}"

        doc = documentation
        entry << ", #{doc}" if doc

        entry
      end

      private

      def validate_parameters(definition:, components:)
        return :direct if definition.key?('name')
        return :ref if definition.key?('$ref') && components.key?('parameters')

        raise Error, 'no valid combination given'
      end

      def prepare_attributes(definition:, components:)
        case kind
        when :direct
          @name = definition['name']
          @definition = definition.except('name')
        when :ref
          found = components.dig(*definition['$ref'].split('/')[2..])
          @name = found['name']
          @definition = found.except('name')

          if (value = @definition.dig('schema', '$ref').presence)
            @definition['schema'] = components.dig(*value.split('/')[2..])
          end
        end
      end

      def documentation
        tmp = {}
        tmp['desc'] = definition['description'] if definition.key?('description')
        tmp['in'] = definition['in'] if definition.key?('in')

        return nil if tmp.empty?

        documentation = 'documentation:'
        documentation.tap do |doc|
          doc << ' { '
          content = tmp.map { |k, v| "#{k}: '#{v}'" }
          doc << content.join(', ')
          doc << ' }'
        end

        documentation
      end
    end
  end
end
