# frozen_string_literal: true
module Api
  module Rake
    class Names
      class << self
        def build(resource)
          @resource = resource

          {
            klass_name: klass_name,
            base_file_name: base_file_name,
            'singular?': singular?
          }
        end

        def klass_name
          for_klass = prepare_klass
          singular? ? for_klass.classify : for_klass.classify.pluralize
        end

        def base_file_name
          @resource.tr('/', '-')
        end

        private

        def prepare_klass
          @resource.tr('-', '/')
        end

        def singular?
          @resource.singularize.inspect == @resource.inspect
        end
      end
    end
  end
end
