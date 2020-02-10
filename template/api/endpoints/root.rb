# frozen_string_literal: true

require 'starter/rake/grape_tasks'

module Api
  module Endpoints
    class Root < Grape::API
      namespace :root do
        desc 'Exposes all routes' do
          success Entities::Route
          is_array true
        end
        get do
          api_routes = Starter::Rake::GrapeTasks.new(::Api::Base).api_routes

          present :count, api_routes.length
          present :items, api_routes, with: Entities::Route
        end
      end
    end
  end
end
