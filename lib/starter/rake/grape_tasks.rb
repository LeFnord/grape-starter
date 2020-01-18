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
        routes
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
      def print_routes(routes_array)
        routes_array.each do |route|
          puts "\t#{route[:verb].ljust(7)}#{route[:path].ljust(42)}#{route[:description]}"
        end
      end

      def build_path(route)
        path = route.path

        path = path.sub(/\(\.\w+?\)$/, '')
        path = path.sub('(.:format)', '')

        if route.version
          path.sub(':version', route.version.to_s)
        else
          path.sub('/:version', '')
        end
      end

      def app
        api_class.new
      end
    end
  end
end
