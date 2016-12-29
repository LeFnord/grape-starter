# frozen_string_literal: true
module Starter
  module Template
    # defining the endpoints -> http methods of a resource
    module Endpoints
      def crud
        %i(
          post
          get_all
          get_specific
          put_specific
          patch_specific
          delete_specific
        )
      end

      def singular_one
        %i(
          post
          get_one
          put_one
          patch_one
          delete_one
        )
      end

      # available API/HTTP methods
      # POST
      def post
        "
        desc 'create #{resource.singularize}'
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
        desc 'get all of #{resource.pluralize}',
        is_array: true
        get do
          # your code goes here
        end"
      end

      %w(get put patch delete).each do |verb|
        define_method(:"#{verb}_one") do
          "
          desc '#{verb} #{resource.singularize}'
          #{verb} do
            # your code goes here
          end"
        end
      end

      %w(get put patch delete).each do |verb|
        define_method(:"#{verb}_specific") do
          "
          desc '#{verb} specific #{resource.singularize}'
          params do
            requires :id
          end
          #{verb} ':id' do
            # your code goes here
            present :params, params
          end"
        end
      end

      # request specs shared examples
      #
      def post_spec
        "it_behaves_like 'POST', params: {}"
      end

      def get_all_spec
        "it_behaves_like 'GET all'"
      end

      %w(get delete).each do |verb|
        define_method(:"#{verb}_one_spec") do
          "it_behaves_like '#{verb.upcase} one'"
        end
      end

      %w(put patch).each do |verb|
        define_method(:"#{verb}_one_spec") do
          "it_behaves_like '#{verb.upcase} one', params: {}"
        end
      end

      %w(get delete).each do |verb|
        define_method(:"#{verb}_specific_spec") do
          "it_behaves_like '#{verb.upcase} specific', key: 1"
        end
      end

      %w(put patch).each do |verb|
        define_method(:"#{verb}_specific_spec") do
          "it_behaves_like '#{verb.upcase} specific', key: 1, params: {}"
        end
      end
    end
  end
end
