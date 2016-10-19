# frozen_string_literal: true
module Api
  module Rake
    require 'api/rake/names'
    require 'api/rake/template'
    class Builder
      extend Template

      class << self
        def build(resource)
          @resource = resource
          build_name_methods
          self
        end

        def resource
          @resource
        end

        def endpoints
          'defining endpoints'
        end

        private

        def build_name_methods
          Api::Rake::Names.build(@resource).each do |name|
            self.class.send(:define_method, name.first, -> { name.last })
          end
        end
      end
    end
  end
end
