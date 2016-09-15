module Api
  module Rake
    class Names
      class << self
        def build(resource)
          @resource = resource
          @singular = singular?

          {
            resource_class: resource_class,
            mount_in_base: mount_in_base,
            resource_namespace: resource_namespace,
            resource_file: resource_file,
            lib_file: lib_file
          }
        end

        # needed for building new endpoint(s) for resource
        # under: api/endpoints/@resource
        def resource_file
          File.join(prepare_file_path(APP_CLASS), 'endpoints', prepare_file_path(@resource))
        end

        def resource_class
          prepare_file_path(@resource).camelize
        end

        def resource_namespace
          namespace = prepare_file_path(@resource)
          namespace.split('/').map(&:downcase).map(&:to_sym)
        end

        def mount_in_base
          "mount #{resource_file.camelize}"
        end

        # needed for building related lib file
        # under: lib/api/endpoints
        def lib_file
          File.join('lib', resource_file)
        end

        private

        def singular?
          @resource.singularize == @resurce
        end

        def prepare_file_path(part)
          part.singularize == part ? part.tableize.singularize : part.tableize
        end
      end
    end
  end
end
