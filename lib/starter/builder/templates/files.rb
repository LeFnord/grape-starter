# frozen_string_literal: true

require 'active_support/core_ext/string'

module Starter
  module Templates
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

        module Models
          class #{klass_name}
          end
        end
        FILE
      end

      def api_spec
        <<-FILE.strip_heredoc
        # frozen_string_literal: true
        require 'spec_helper'

        RSpec.describe '/#{base_prefix}/#{base_version}/#{resource}' do
          #{endpoint_specs}
        end
        FILE
      end

      def lib_spec
        <<-FILE.strip_heredoc
        # frozen_string_literal: true
        require 'spec_helper'

        RSpec.describe Models::#{klass_name} do
          pending 'write specs'
        end
        FILE
      end
    end
  end
end
