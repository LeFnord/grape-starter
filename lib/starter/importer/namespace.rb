# frozen_string_literal: false

module Starter
  module Importer
    class Namespace
      attr_accessor :naming, :paths, :components

      def initialize(naming:, paths:, components:)
        @naming = naming
        @paths = paths
        @components = components
      end

      def content
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        module Api
          module Endpoints
            class #{@naming.klass_name} < Grape::API
              namespace #{namespace} do
                #{endpoints.join("\n")}
              end
            end
          end
        end
        FILE
      end

      private

      def namespace
        naming.version_klass ? "'#{naming.origin}'" : ":#{naming.resource.downcase}"
      end

      def endpoints
        paths.map do |path, verbs|
          segment = prepare_route(path)
          verbs.keys.each_with_object([]) do |verb, memo|
            next unless allowed_verbs.include?(verb)

            if (parameters = verbs[verb]['parameters'].presence)
              params_block = params_block(parameters)
              memo << params_block
            end
            memo << "#{verb} '#{segment}' do\n  # your code comes here\nend\n"
          end
        end
      end

      def prepare_route(path)
        params = path.scan(/\{(\w+)\}/)
        if params.empty?
          path
        else
          path.gsub('{', ':').gsub('}', '')
        end
      end

      def params_block(params)
        params_block = "params do\n"
        params.each_value do |param|
          params_block << "  #{param.to_s}\n" # rubocop:disable Lint/RedundantStringCoercion
        end
        params_block << 'end'
      end

      def allowed_verbs
        %w[get put post delete]
      end
    end
  end
end
