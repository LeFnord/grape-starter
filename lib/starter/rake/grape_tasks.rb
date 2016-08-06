require 'rake'
require 'rake/tasklib'
require 'rack/test'

module Starter
  module Rake
    class GrapeTasks < ::Rake::TaskLib
      include Rack::Test::Methods

      attr_reader :swagger

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
          swagger
          routes
        end
      end

      # tasks
      #
      # get swagger/OpenAPI documentation
      def swagger
        desc 'generates swagger documentation (`store=true`, stores to FS)'
        task swagger: :environment do
          file = File.join(Dir.getwd, file_name)

          make_request
          ENV['store'] ? File.write(file, @swagger) : print(@swagger)
        end
      end

      # show API routes
      def routes
        desc 'shows all routes'
        task routes: :environment do
          print_routes api_routes
        end
      end

      # helper methods
      #
      def make_request
        get url_for
        last_response
        @swagger = JSON.pretty_generate(
          JSON.parse(
            last_response.body, symolize_names: true
          )
        )
      end

      def url_for
        swagger_route = api_class.routes[-2]
        url = '/swagger_doc'
        url = "/#{swagger_route.version}#{url}" if swagger_route.version
        url = "/#{swagger_route.prefix}#{url}" if swagger_route.prefix
        url
      end

      def file_name
        'swagger_doc.json'
      end

      def app
        api_class.new
      end

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
    end
  end
end
