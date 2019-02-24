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
      def base_namespace_file
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        module #{klass_name}
          VERSION  = '0.1.0'
        end
        FILE
      end

      def lib_file
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        module Models
          class #{lib_klass_name}
          end
        end
        FILE
      end

      def api_spec
        prefix = base_prefix ? "/#{base_prefix}" : ''
        <<-FILE.strip_heredoc
        # frozen_string_literal: true

        require 'spec_helper'

        RSpec.describe '#{prefix}/#{base_version}/#{resource.downcase}' do
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
