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

        def save_files
          File.open(api_file_name, 'w+') { |file| file.write(resource_file) }
          File.open(lib_file_name, 'w+') { |file| file.write(resource_lib) }
        end

        def resource
          @resource
        end

        def endpoints
          enpoint_configuration(4).join("\n\n")
        end

        private

        def enpoint_configuration(deep)
          [
            create,
            get_all,
            get_specific,
            update_specific,
            delete_specific
          ].map { |x| indent(x, deep) }
        end

        def build_name_methods
          Api::Rake::Names.build(@resource).each do |name|
            self.class.send(:define_method, name.first, -> { name.last })
          end
        end
      end
    end
  end
end
