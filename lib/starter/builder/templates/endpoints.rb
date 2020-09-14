# frozen_string_literal: true

module Starter
  module Templates
    # defining the endpoints -> http methods of a resource
    module Endpoints
      def crud
        %i[
          post
          get_all
          get_specific
          put_specific
          patch_specific
          delete_specific
        ]
      end

      def singular_one
        %i[
          post
          get_one
          put_one
          patch_one
          delete_one
        ]
      end

      # available API/HTTP methods
      # POST
      def post
        "
        desc 'create #{resource.singularize}' do
          tags %w[#{resource.singularize}]
        end
        params do
          # TODO: specify the parameters
        end
        post do
          # your code goes here
        end"
      end

      # GET
      def get_all
        "
        desc 'get all of #{resource.pluralize}' do
          is_array true
          tags %w[#{resource.singularize}]
        end
        get do
          # your code goes here
        end"
      end

      # rubocop:disable Style/CombinableLoops
      %w[get put patch delete].each do |verb|
        define_method(:"#{verb}_one") do
          "
          desc '#{verb} #{resource.singularize}' do
            tags %w[#{resource.singularize}]
          end
          #{verb} do
            # your code goes here
          end"
        end
      end

      %w[get put patch delete].each do |verb|
        define_method(:"#{verb}_specific") do
          "
          desc '#{verb} specific #{resource.singularize}' do
            tags %w[#{resource.singularize}]
          end
          params do
            requires :id
          end
          #{verb} ':id' do
            # your code goes here
          end"
        end
      end
      # rubocop:enable Style/CombinableLoops

      # request specs shared examples
      #
      def post_spec
        "it_behaves_like 'POST', params: {}"
      end

      def get_all_spec
        "it_behaves_like 'GET all'"
      end

      %w[get delete].each do |verb|
        define_method(:"#{verb}_one_spec") do
          "it_behaves_like '#{verb.upcase} one'"
        end
      end

      %w[put patch].each do |verb|
        define_method(:"#{verb}_one_spec") do
          "it_behaves_like '#{verb.upcase} one', params: {}"
        end
      end

      %w[get delete].each do |verb|
        define_method(:"#{verb}_specific_spec") do
          "it_behaves_like '#{verb.upcase} specific', key: 1"
        end
      end

      %w[put patch].each do |verb|
        define_method(:"#{verb}_specific_spec") do
          "it_behaves_like '#{verb.upcase} specific', key: 1, params: {}"
        end
      end
    end
  end
end
