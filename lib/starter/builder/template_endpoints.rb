# frozen_string_literal: true
module Starter
  module Template
    # defining the endpoints -> http methods of a resource
    module Endpoints
      def crud
        %i(
          create
          get_all
          get_specific
          put_specific
          delete_specific
        )
      end

      def singular_one
        %i(
          create
          get_one
          put_one
          delete_one
        )
      end

      # available APT/HTTP methods
      # POST
      def create
        "
        desc 'create #{resource}'
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
        desc 'get all of #{resource}',
        is_array: true
        get do
          # your code goes here
        end"
      end

      #
      # GET
      def get_one
        "
        desc 'get #{resource}'
        get do
          # your code goes here
        end"
      end

      #
      # GET/:id
      def get_specific
        "
        desc 'get specific #{resource}'
        params do
          requires :id
        end
        get :id do
          # your code goes here
        end"
      end

      # PUT
      def put_one
        "
        desc 'put #{resource}'
        put do
          # your code goes here
        end"
      end

      #
      # PUT/:id
      def put_specific
        "
        desc 'put specific #{resource}'
        params do
          requires :id
        end
        put :id do
          # your code goes here
        end"
      end

      # DELETE
      def delete_one
        "
        desc 'delete #{resource}'
        delete do
          # your code goes here
        end"
      end

      #
      # DELETE/:id
      def delete_specific
        "
        desc 'delete specific #{resource}'
        params do
          requires :id
        end
        delete :id do
          # your code goes here
        end"
      end
    end
  end
end
