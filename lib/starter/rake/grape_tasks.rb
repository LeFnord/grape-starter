# frozen_string_literal: true
require 'rake'
require 'rake/tasklib'
require 'rack/test'

module Starter
  module Rake
    require 'starter/builder'

    class GrapeTasks < ::Rake::TaskLib
      include Rack::Test::Methods

      attr_reader :resource
      attr_reader :api_class

      def initialize(api_class = nil)
        super()

        @api_class = api_class
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
        desc 'add a new resource given by `resource=name` (required)'
        task add: :environment do
          exit unless resource?
          Builder.build(resource)
          Builder.save
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
