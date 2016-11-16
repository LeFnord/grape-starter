# frozen_string_literal: true
require 'active_support/core_ext/string'

module Template
  module Files
    # API template for resource
    def resource_file
      <<-FILE.strip_heredoc
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
    def resource_lib
      <<-FILE.strip_heredoc
      module Api
        class #{klass_name}
        end
      end
      FILE
    end
  end
end
