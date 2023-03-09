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

          memo[namespace] ||= {}
          memo[namespace][rest_path] = paths[path]
        end
      end

      private

      def validate_paths
        raise Error, '`paths` empty … nothings to do' if paths.empty?
        raise Error, 'only template given' if paths.keys.one? && paths.keys.first.match?(%r{/\{\w*\}})
      end
    end
  end
end
