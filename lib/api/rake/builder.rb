# frozen_string_literal: true
module Api
  module Rake
    require 'api/rake/names'
    require 'api/rake/template_files'
    require 'api/rake/template_endpoints'
    class Builder
      extend Template::Files
      extend Template::Endpoints

      class << self
        def build(resource)
          @resource = resource
          build_name_methods

          self
        end

        def save
          File.open(api_file_name, 'w+') { |file| file.write(resource_file) }
          File.open(lib_file_name, 'w+') { |file| file.write(resource_lib) }
          add_moint_point
        end

        def resource
          @resource
        end

        def endpoints
          endpoint_object.join("\n\n")
        end

        def endpoint_object
          enpoint_configuration(crud, 4)
        end

        private

        def add_moint_point
          file = File.read(api_base_file_name)
          occurence = file.scan(/(\s+mount.*?\n)/).last.first
          replacement = occurence + "    mount Endpoints::#{klass_name}\n"
          file.sub!(occurence, replacement)
          File.open(api_base_file_name, 'w') { |f| f.write(file) }
        end

        def enpoint_configuration(set, deep)
          set.map { |x| send(x) }.map { |x| indent(x, deep) }
        end

        def indent(endpoint, deep)
          indentation = '  ' * deep

          endpoint.split("\n").map { |x| x.prepend(indentation) }.join("\n")
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
