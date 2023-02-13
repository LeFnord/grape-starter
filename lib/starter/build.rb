# frozen_string_literal: true

module Starter
  class Build
    extend Builder::Names
    extend Builder::BaseFile
    extend Builder::Templates::Files
    extend Builder::Templates::Endpoints

    class << self
      attr_reader :prefix, :resource, :set, :force, :entity, :destination, :orm

      #
      # public methods
      #
      #
      # would be called from new command
      #
      # name - A String as project name,
      #        it will also be the namespace in the lib folder
      # source - A String which provides the template path
      # destination - A String which provides the new project path
      # options - A Hash to provide some optional arguments (default: {})
      #   :prefix - Sets the Prefix for the API
      #   :orm - Sets and creates ORM specific files
      def new!(name, source, destination, options = {})
        @resource = name
        @destination = destination
        @prefix = options[:p] # can be nil

        FileUtils.copy_entry source, destination

        config_static.each do |config|
          replace_static(File.join(config[:file]), config[:pattern])
        end

        add_namespace_with_version

        Orms.build(name, destination, options[:orm]) if options[:orm]

        Starter::Config.save(
          dest: destination,
          content: { prefix: prefix, orm: options[:orm].to_s }
        )

        self
      end

      # would be called from add command
      #
      # resource - A String as name
      # options - A Hash to provide some optional arguments (default: {})
      #   :resource - the name of the resource to create
      #   :set – Whitespace separated list of http verbs
      #          (default: nil, possible: post get put patch delete)
      #   :force - A Boolean, if given existent files should be overwriten (default: false)
      #   :entity - A Boolean, if given an entity file would be created (default: false)
      #   :orm - A Boolean, if given the created lib/model file will be inherited orm specific (default: false)
      def add!(resource, options = {})
        @resource = resource
        @set = options[:set]
        @force = options[:force]
        @entity = options[:entity]
        @orm = options[:orm]

        Orms.add_migration(klass_name, resource.downcase) if @orm
        save_resource
      end

      # would be called on from rm command
      #
      # resource - A String, which indicates the resource to remove
      # options - A Hash to provide some optional arguments (default: {})
      #   :entity - A Boolean, if given an entity file would also be removed (default: nil -> false)
      def remove!(resource, options = {})
        @resource = resource
        @entity = options[:entity]

        file_list.map { |x| send("#{x}_name") }.each do |file_to_remove|
          FileUtils.rm file_to_remove
        rescue StandardError => e
          $stdout.puts e.to_s
        end

        remove_mount_point
      end

      # provides the endpoints for the given resource
      def endpoints
        content(endpoint_set).join("\n\n")
      end

      # provides the specs for the endpoints of the resource
      def endpoint_specs
        content(endpoint_set.map { |x| "#{x}_spec" }).join("\n")
      end

      private

      # #new! project creation releated helper methods
      #
      # defines static files to be created
      def config_static
        [
          { file: %w[script server], pattern: "API-#{resource}" },
          { file: %w[api base.rb], pattern: prefix ? "prefix :#{prefix}" : nil },
          { file: %w[spec requests root_spec.rb], pattern: prefix ? "/#{prefix}" : nil },
          { file: %w[spec requests documentation_spec.rb], pattern: prefix ? "/#{prefix}" : nil }
        ]
      end

      #
      # creates a new file in lib folder as namespace, includind the version
      def add_namespace_with_version
        new_lib = File.join(destination, 'lib', base_file_name)
        FileOps.write_file(new_lib, base_namespace_file.strip_heredoc)
      end

      #
      # replace something in static files
      def replace_static(file, replacement)
        file_path = File.join(destination, file)

        FileOps.call!(file_path) { |content| content.gsub!('{{{grape-starter}}}', replacement.to_s) }
      end

      # #add! a new resource releated helper methods
      #
      # provides an array of endpoints for the new resource
      def endpoint_set
        crud_set = singular? ? singular_one : crud
        return crud_set if set.blank?

        crud_set.each_with_object([]) { |x, memo| set.map { |y| memo << x if x.to_s.start_with?(y) } }
      end

      #
      # saves all resource related files
      def save_resource
        created_files = file_list.each_with_object([]) do |new_file, memo|
          memo << send("#{new_file}_name")
          save_file(new_file)
        end

        add_mount_point

        created_files
      end

      #
      # saves new resource files
      def save_file(new_file)
        new_file_name = send("#{new_file}_name")
        should_raise?(new_file_name)
        FileOps.write_file(new_file_name, send(new_file.strip_heredoc))
      end

      #
      # raises if resource exist and force false
      def should_raise?(file)
        raise StandardError, '… resource exists' if File.exist?(file) && !force
      end

      # #add! and #remove! a new resource releated helper methods
      #
      # provides a file list for the new resource
      def file_list
        standards = %w[api_file lib_file api_spec lib_spec]

        entity ? standards + ['entity_file'] : standards
      end

      # content of the given set of files,
      def content(set)
        set.map { |x| send(x) }
      end
    end
  end
end
