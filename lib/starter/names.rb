# frozen_string_literal: true

module Starter
  class Names
    attr_accessor :resource, :origin, :version_klass

    def initialize(resource)
      @version_klass = false
      @origin = resource
      @resource = if resource.match?(/([[:digit:]][[:punct:]])+/)
                    @version_klass = true
                    digit = resource.scan(/\d/).first.to_i - 1
                    letter = ('a'..'z').to_a[digit]
                    "#{letter}_#{resource.tr('.', '_')}"
                  else
                    resource
                  end
    end

    def klass_name
      return @resource.classify if version_klass

      for_klass = @resource.tr('-', '/')
      singular? ? for_klass.classify : for_klass.classify.pluralize
    end

    # rubocop:disable Style/StringConcatenation
    def resource_file
      @resource.tr('/', '-').downcase + '.rb'
    end
    # rubocop:enable Style/StringConcatenation

    def resource_spec
      resource_file.gsub(/.rb$/, '_spec.rb')
    end

    # entry in api/base.rb
    def mount_point
      "    mount Endpoints::#{klass_name}\n"
    end

    # endpoints file
    def api_file_name
      File.join(Dir.getwd, 'api', 'endpoints', resource_file)
    end

    # entities file
    def entity_file_name
      File.join(Dir.getwd, 'api', 'entities', resource_file)
    end

    # lib file
    def lib_file_name
      File.join(Dir.getwd, 'lib', 'models', resource_file)
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
      File.join(Dir.getwd, 'spec', 'requests', resource_spec)
    end

    # lib spec
    def lib_spec_name
      File.join(Dir.getwd, 'spec', 'lib', 'models', resource_spec)
    end

    def singular?
      @resource.singularize.inspect == @resource.inspect
    end
  end
end
