# frozen_string_literal: true

module Starter
  module Importer
    class Specification
      class Error < StandardError; end

      attr_accessor :openapi, :info,
                    :paths, :components, :webhooks

      def initialize(raw)
        # mandatory
        @openapi = raw.fetch('openapi')
        @info = raw.fetch('info')

        # in contrast to the spec, paths are required
        @paths = raw.fetch('paths').except('/').sort.to_h

        # optional -> not used atm
        @components = raw.fetch('components', false)
        @webhooks = raw.fetch('webhooks', false)
      end

      def namespaces
        validate_paths

        @namespaces ||= paths.keys.each_with_object({}) do |path, memo|
          segments = path.split('/').delete_if(&:empty?)
          namespace = segments.shift
          rest_path = "/#{segments.join('/')}"

          # TODO: build additional stuff from `paths[path]`
          memo[namespace] ||= {}
          memo[namespace][rest_path] = prepare_verbs(paths[path])
        end
      end

      private

      def validate_paths
        raise Error, '`paths` empty … nothings to do' if paths.empty?
        raise Error, 'only template given' if paths.keys.one? && paths.keys.first.match?(%r{/\{\w*\}})
      end

      def prepare_verbs(spec)
        path_params = nil
        spec.each_with_object({}) do |(verb, content), memo|
          if verb == 'parameters'
            path_params = content
            next
          end

          memo[verb] = content
          next unless content.key?('parameters') || path_params

          parameters = content['parameters'] || path_params

          memo[verb]['parameters'] = parameters.each_with_object({}) do |definition, para|
            parameter = Parameter.new(definition:, components:)
            para[parameter.name] = parameter
          end
        end
      end
    end
  end
end
