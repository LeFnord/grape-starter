# frozen_string_literal: true

module Starter
  module Importer
    class Namespace
      attr_accessor :resource, :paths, :components

      def initialize(resource:, paths:, components:)
        @resource = resource
        @paths = paths
        @components = components
      end

      def file
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        module Api
          module Endpoints
            class #{@resource} < Grape::API
              namespace :#{@resource.downcase} do
                #{endpoints.join("\n")}
              end
            end
          end
        end
        FILE
      end

      private

      def endpoints
        paths.map do |path, verbs|
          segment, params = prepare_route(path)
          params_block = route_params(params) if params
          verbs.keys.each_with_object([]) do |verb, memo|
            next unless allowed_verbs.include?(verb)

            memo << params_block if params
            memo << "#{verb} '#{segment}' do\n  # your code comes here\nend\n"
          end
        end
      end

      def prepare_route(path)
        params = path.scan(/\{(\w+)\}/)
        if params.empty?
          [path, false]
        else
          [path.gsub('{', ':').gsub('}', ''), params.flatten]
        end
      end

      def route_params(params)
        params_block = ['params do']
        params.each { |x| params_block << "  requires :#{x}" }
        params_block << 'end'

        params_block.join("\n")
      end

      def allowed_verbs
        %w[get put post delete]
      end
    end
  end
end
