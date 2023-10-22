# frozen_string_literal: true

module Starter
  module Importer
    class Specification
      class Error < StandardError; end

      attr_accessor :openapi, :info,
                    :paths, :components, :webhooks

      def initialize(spec:)
        # mandatory
        @openapi = spec.fetch('openapi')
        @info = spec.fetch('info')

        # in contrast to the spec, paths are required
        @paths = spec.fetch('paths').except('/').sort.to_h

        # optional -> not used atm
        @components = spec.fetch('components', false)
        @webhooks = spec.fetch('webhooks', false)
      end

      def namespaces
        validate_paths

        @namespaces ||= paths.keys.each_with_object({}) do |path, memo|
          namespace, rest_path = segmentize(path)

          memo[namespace] ||= {}
          memo[namespace][rest_path] = prepare_verbs(paths[path])
        end
      end

      private

      def validate_paths
        raise Error, '`paths` empty … nothings to do' if paths.empty?
        raise Error, 'only template given' if paths.keys.one? && paths.keys.first.match?(%r{/\{\w*\}})
      end

      def segmentize(path)
        segments = path.split('/').delete_if(&:empty?)
        ignore = segments.take_while { |x| x =~ /(v)*(\.\d)+/ || x =~ /(v\d)+/ || x == 'api' }
        rest = segments - ignore

        [rest.shift, rest.empty? ? '/' : "/#{rest.join('/')}"]
      end

      def prepare_verbs(spec) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        path_params = nil
        spec.each_with_object({}) do |(verb, content), memo|
          if verb == 'parameters'
            path_params = content
            next
          end

          memo[verb] = content
          next unless content.key?('parameters') || content.key?('requestBody') || path_params

          parameters = ((content.delete('parameters') || path_params || []) + [content.delete('requestBody')]).compact

          memo[verb]['describe'] = Description.new(content: content.except('responses'))

          memo[verb]['parameters'] = parameters.each_with_object({}) do |definition, para|
            parameter = Parameter.new(definition:, components:)
            para[parameter.name] = parameter
          end
        end
      end
    end
  end
end
