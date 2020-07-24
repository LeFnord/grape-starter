# frozen_string_literal: true

module Starter
  module Names
    def klass_name
      for_klass = prepare_klass
      singular? ? for_klass.classify : for_klass.classify.pluralize
    end

    def lib_klass_name
      return klass_name unless @orm

      case ::Starter::Config.read[:orm]
      when 'sequel'
        require 'starter/builder/templates/sequel'
        extend(::Starter::Templates::Sequel)
        "#{klass_name} < #{model_klass}"
      when 'activerecord', 'ar'
        require 'starter/builder/templates/activerecord'
        extend(::Starter::Templates::ActiveRecord)
        "#{klass_name} < #{model_klass}"
      else
        klass_name
      end
    end

    # rubocop:disable Style/StringConcatenation
    def base_file_name
      @resource.tr('/', '-').downcase + '.rb'
    end
    # rubocop:enable Style/StringConcatenation

    def base_spec_name
      base_file_name.gsub(/.rb$/, '_spec.rb')
    end

    def mount_point
      "    mount Endpoints::#{klass_name}\n"
    end

    def api_base_file_name
      File.join(Dir.getwd, 'api', 'base.rb')
    end

    # resource file
    def api_file_name
      File.join(Dir.getwd, 'api', 'endpoints', base_file_name)
    end

    # resource file
    def entity_file_name
      File.join(Dir.getwd, 'api', 'entities', base_file_name)
    end

    # lib file
    def lib_file_name
      File.join(Dir.getwd, 'lib', 'models', base_file_name)
    end

    # resource spec
    def api_spec_name
      File.join(Dir.getwd, 'spec', 'requests', base_spec_name)
    end

    # lib spec
    def lib_spec_name
      File.join(Dir.getwd, 'spec', 'lib', 'models', base_spec_name)
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
