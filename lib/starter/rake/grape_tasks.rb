require 'rake'
require 'rake/tasklib'
require 'rack/test'

module Starter
  module Rake
    class GrapeTasks < ::Rake::TaskLib
      include Rack::Test::Methods

      attr_accessor :swagger
      def initialize
        super
        define_tasks
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
        desc 'generates swagger documentation (`store=`, stores to FS)'
        task swagger: :environment do
          name = file_name
          file = File.join(Dir.getwd, name)

          make_request
          if ENV['store']
            File.write(file, JSON.pretty_generate(@swagger))
          else
            print JSON.pretty_generate(@swagger)
          end
        end
      end

      # show API routes
      def routes
        desc 'shows all routes'
        task routes: :environment do
          Starter::Base.routes.each do |route|
            method = route.request_method.ljust(10)
            path = route.origin
            puts "     #{method} #{path}"
          end
        end
      end

      # helper methods
      #
      def make_request
        get '/api/v1/swagger_doc'
        last_response
        @swagger = JSON.parse(last_response.body, symolize_names: true)
      end

      def file_name
        'swagger_doc.json'
      end

      def app
        Starter::Base.new
      end
    end
  end
end
