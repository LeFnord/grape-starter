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

      def entity_file
        <<-FILE.strip_heredoc
        # frozen_string_literal: true
        module Api
          module Entities
            class #{klass_name} < Grape::Entity
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

      def api_spec
        <<-FILE.strip_heredoc
        # frozen_string_literal: true
        require 'spec_helper'
        RSpec.describe Api::#{klass_name} do
          pending 'write specs'
        end
        FILE
      end

      alias lib_spec api_spec
    end
  end
end
