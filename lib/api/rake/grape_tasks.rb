# frozen_string_literal: true
require 'rake'
require 'rake/tasklib'
require 'rack/test'

module Api
  module Rake
    class GrapeTasks < ::Rake::TaskLib
      include Rack::Test::Methods

      attr_reader :resource

      def api_class
        Api::Base
      end

      def initialize
        super
        define_tasks
      end

      def api_routes
        api_class.routes.each_with_object([]) do |route, memo|
          memo << { verb: route.request_method, path: build_path(route), description: route.description }
        end
      end

      private

      def define_tasks
        namespace :grape do
          add
          routes
        end
      end

      # tasks
      #
      # adds a skeleton for a new resource
      # TODO:
      # needed files and entries:
      # - CRUD resource      -> mount in Api::Base
      # - a related lib file -> require in lib/api.rb
      def add
        desc 'add a new resource  …
          params (usage: key=value):
          resource - if given only for that it would be generated (required)'
        task add: :environment do
          exit unless resource?
          # TODO: steps to create:
          # - create api file
          #   - add methods to file
          #   - mount in base
          # - create lib file
          #   - require it
          #
          # -> file operations
          # -> string manipulation
          # => Builder
          Builder.call!(resource)
          $stdout.puts "added new resource: #{resource}"
        end
      end

      # gets all api routes
      def routes
        desc 'shows all routes'
        task routes: :environment do
          print_routes api_routes
        end
      end

      # helper methods
      #
      # ... for `add` task
      #
      def resource?
        ENV['resource'] && !ENV['resource'].blank? ? @resource = ENV['resource'] : false
      end

      # ... for `routes` task
      #
      def print_routes(routes_array)
        routes_array.each do |route|
          puts "\t#{route[:verb].ljust(7)}#{route[:path].ljust(42)}#{route[:description]}"
        end
      end

      def build_path(route)
        path = route.path

        path.sub!(/\(\.\w+?\)$/, '')
        path.sub!('(.:format)', '')

        if route.version
          path.sub!(':version', route.version.to_s)
        else
          path.sub!('/:version', '')
        end

        path
      end

      def app
        api_class.new
      end
    end
  end
end

Api::Rake::GrapeTasks.new
