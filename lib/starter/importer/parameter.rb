# rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ClassLength
# frozen_string_literal: false

module Starter
  module Importer
    class Parameter
      class Error < StandardError; end

      attr_accessor :kind, :name, :definition, :nested

      def initialize(definition:, components: {})
        @nested = []
        @kind = validate_parameters(definition:, components:)
        prepare_attributes(definition:, components:)
      end

      def to_s
        return serialized_object if nested?

        serialized
      end

      def nested?
        @nested.present?
      end

      # initialize helper
      #
      def validate_parameters(definition:, components:)
        return :direct if definition.key?('name')
        return :ref if definition.key?('$ref') && components.key?('parameters')
        return :body if definition.key?('content')

        raise Error, 'no valid combination given'
      end

      def prepare_attributes(definition:, components:) # rubocop:disable Metrics/MethodLength
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
        when :body
          definition['in'] = 'body'
          schema = definition['content'] ? definition['content'].values.first['schema'] : definition
          if schema.key?('$ref')
            path = schema['$ref'].split('/')[2..]

            @name, @definition = handle_body(definition:, properties: components.dig(*path))
            @name ||= path.last
          else
            @name, @definition = handle_body(definition:, properties: schema)
            @name = nested.map(&:name).join('_') if @name.nil? && nested?
          end
        end
      end

      def handle_body(definition:, properties:) # rubocop:disable Metrics/MethodLength
        if simple_object?(properties:)
          name = properties['properties'].keys.first
          type = properties.dig('properties', name, 'type') || 'array'
          subtype = properties.dig('properties', name, 'items', 'type')
          definition['type'] = subtype.nil? ? type : "#{type}[#{subtype}]"

          properties.dig('properties', name).except('type').each { |k, v| definition[k] = v }
          definition['type'] = 'file' if definition['format'].presence == 'binary'

          [name, definition]
        elsif object?(definition:) # a nested object -> JSON
          definition['type'] = properties['type'].presence || 'JSON'
          return [nil, definition] if properties.nil? || properties['properties'].nil?

          properties['properties'].each do |nested_name, nested_definition|
            nested_definition['required'] = required?(properties, nested_name)
            nested = NestedParams.new(name: nested_name, definition: nested_definition)
            nested.prepare_attributes(definition: nested.definition, components: {})
            nested.name = nested_name
            @nested << nested
          end

          [self.name, definition]
        else # others
          [nil, properties ? definition.merge(properties) : definition]
        end
      end

      # handle_body helper, check/find/define types
      #
      def object?(definition:)
        definition['type'] == 'object' ||
          definition['content']&.keys&.first&.include?('application/json')
      end

      def simple_object?(properties:)
        list_of_object?(properties:) &&
          properties['properties'].length == 1
      end

      def list_of_object?(properties:)
        properties&.key?('properties')
      end

      def required?(property, name)
        return false unless property['required']

        property['required'].is_a?(Array) ? property['required'].include?(name) : property['required']
      end

      # to_s helper
      #
      def serialized_object
        definition.tap do |foo|
          foo['type'] = foo['type'] == 'object' ? 'JSON' : foo['type']
        end

        parent = NestedParams.new(name: name, definition: definition)
        entry = "#{parent} do\n"
        nested.each { |n| entry << "    #{n}\n" }
        entry << '  end'
        if entry.include?("format: 'binary', type: 'File'")
          entry.sub!('type: JSON', 'type: Hash')
          entry.sub!(", documentation: { in: 'body' }", '')
          entry.gsub!(", in: 'body'", '')
        end

        entry
      end

      def serialized
        type = definition['type'] || definition['schema']['type']
        type.scan(/\w+/).each { |x| type.match?('JSON') ? type : type.sub!(x, x.capitalize) }

        if type == 'Array' && definition.key?('items')
          sub = definition.dig('items', 'type').to_s.capitalize
          type = "#{type}[#{sub}]"
        end

        entry = definition['required'] ? 'requires' : 'optional'
        entry << " :#{name}"
        entry << ", type: #{type}"
        entry << ", default: '#{definition['default']}'" if definition.key?('default') && definition['default'].present?
        entry << ", values: #{definition['enum'].map(&:to_s)}" if definition.key?('enum')
        doc = documentation
        entry << ", #{doc}" if doc

        entry
      end

      def documentation
        @documentation ||= begin
          tmp = {}
          tmp['desc'] = definition['description'] if definition.key?('description')
          if definition.key?('in') && !(definition['type'] == 'File' && definition['format'] == 'binary')
            tmp['in'] = definition['in']
          end

          if definition.key?('format')
            tmp['format'] = definition['format']
            tmp['type'] = 'File' if definition['format'] == 'binary'
          end

          documentation = 'documentation:'
          documentation.tap do |doc|
            doc << ' { '
            content = tmp.map { |k, v| "#{k}: '#{v}'" }
            doc << content.join(', ')
            doc << ' }'
          end
        end
      end
    end
  end
end

# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ClassLength
