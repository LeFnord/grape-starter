# frozen_string_literal: true

module Starter
  module Importer
    class Parameter
      class Error < StandardError; end

      attr_accessor :kind, :name, :definition

      def initialize(definition:, components: {})
        @kind = validate_parameters(definition:, components:)
        prepare_attributes(definition:, components:)
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
          @name = definition.delete('name')
          @definition = definition
        when :ref
          @definition = components.dig(*definition['$ref'].split('/')[2..])
          @name = @definition.delete('name')

          if (value = @definition.dig('schema', '$ref').presence)
            @definition['schema'] = components.dig(*value.split('/')[2..])
          end
        end
      end
    end
  end
end
