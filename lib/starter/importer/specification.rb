# frozen_string_literal: true

module Starter
  module Importer
    class Specification
      class Error < StandardError; end

      attr_accessor :openapi, :info,
                    :paths, :components, :webhooks

      def initialize(raw)
        # mandatory
        @openapi = raw.fetch(:openapi)
        @info = raw.fetch(:info)
        # optional, but one must be given
        @paths = raw.fetch(:paths, false)
        @components = raw.fetch(:components, false)
        @webhooks = raw.fetch(:webhooks, false)

        raise Error, 'one of `paths`, `components`, `webhooks` must be given' unless optional_valid?
      end

      private

      def optional_valid?
        paths || components || webhooks
      end
    end
  end
end
