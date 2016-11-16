# frozen_string_literal: true
module Api
  module Rake
    class Names
      class << self
        def build(resource)
          @resource = resource

          {
            'singular?': singular?,
            klass_name: klass_name,
            base_file_name: base_file_name,
            api_file_name: api_file_name,
            lib_file_name: lib_file_name,
            api_base_file_name: api_base_file_name
          }
        end

        def klass_name
          for_klass = prepare_klass
          singular? ? for_klass.classify : for_klass.classify.pluralize
        end

        def base_file_name
          @resource.tr('/', '-').downcase + '.rb'
        end

        def api_base_file_name
          File.join(Dir.getwd, 'api', 'base.rb')
        end

        def api_file_name
          File.join(Dir.getwd, 'api', 'endpoints', base_file_name)
        end

        def lib_file_name
          File.join(Dir.getwd, 'lib', 'api', base_file_name)
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
