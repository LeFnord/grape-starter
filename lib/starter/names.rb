# frozen_string_literal: true

module Starter
  class Names
    def initialize(resource)
      @resource = resource
    end

    def klass_name
      for_klass = @resource.tr('-', '/')
      singular? ? for_klass.classify : for_klass.classify.pluralize
    end

    # rubocop:disable Style/StringConcatenation
    def base_file_name
      @resource.tr('/', '-').downcase + '.rb'
    end
    # rubocop:enable Style/StringConcatenation

    def base_spec_name
      base_file_name.gsub(/.rb$/, '_spec.rb')
    end

    # entry in api/base.rb
    def mount_point
      "    mount Endpoints::#{klass_name}\n"
    end

    # endpoints file
    def api_file_name
      File.join(Dir.getwd, 'api', 'endpoints', base_file_name)
    end

    # entities file
    def entity_file_name
      File.join(Dir.getwd, 'api', 'entities', base_file_name)
    end

    # lib file
    def lib_file_name
      File.join(Dir.getwd, 'lib', 'models', base_file_name)
    end

    # model entry in lib file
    def lib_klass_name
      return klass_name unless @orm

      case Starter::Config.read[:orm]
      when 'sequel'
        extend(Starter::Builder::Sequel)
        "#{klass_name} < #{model_klass}"
      when 'activerecord', 'ar'
        extend(Starter::Builder::ActiveRecord)
        "#{klass_name} < #{model_klass}"
      else
        klass_name
      end
    end

    # resource spec
    def api_spec_name
      File.join(Dir.getwd, 'spec', 'requests', base_spec_name)
    end

    # lib spec
    def lib_spec_name
      File.join(Dir.getwd, 'spec', 'lib', 'models', base_spec_name)
    end

    def singular?
      @resource.singularize.inspect == @resource.inspect
    end
  end
end
