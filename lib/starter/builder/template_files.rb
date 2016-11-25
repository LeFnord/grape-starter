# frozen_string_literal: true
require 'active_support/core_ext/string'

module Starter
  module Template
    module Files
      # API template for resource
      def api_file
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        module Api
          module Endpoints
            class #{klass_name} < Grape::API
              namespace :#{resource.downcase} do
                #{endpoints}
              end
            end
          end
        end
        FILE
      end

      # LIB template for resource
      def lib_file
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        module Api
          class #{klass_name}
          end
        end
        FILE
      end
    end
  end
end
