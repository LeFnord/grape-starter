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

      # def name
      #   @name ||= if definition.key?('$ref')
      #               definition['$ref'].split('/').last
      #             elsif definition.key?('name')
      #               definition['name']
      #             end
      # end

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
          key = definition['$ref'].split('/').last
          @definition = components['parameters'][key]
          @name = @definition.delete('name')
        end
      end
    end
  end
end
