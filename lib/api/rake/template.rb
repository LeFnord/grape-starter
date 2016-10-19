# frozen_string_literal: true
module Template
  # API template for resource
  def resource_file
"module Api
  module Endpoints
    class #{klass_name} < Grape::API
      namespace :#{resource} do
        #{endpoints}
      end
    end
  end
end"
  end

  # LIB template for resource
  def resource_lib
"module Api
  class #{klass_name}
  end
end"
  end

  # TODO: build more use cases
  def standard_crud
    create
    get_all
    get_specific
    update_specific
    delete_specific
  end

  # available APT/HTTP methods
  # POST
  def create
"desc 'create #{resource}'
params do
  # TODO: specify the parameters
end
post do
  # your code goes here
end"
  end

  # GET
  def get_all
"desc 'get all items of #{resource}',
  is_array: true
get do
  # your code goes here
end"
  end

  #
  # GET
  def get_one
"desc 'get #{resource}'
get do
  # your code goes here
end"
  end

  #
  # GET/:id
  def get_specific
"desc 'get #{resource}'
get :id do
  # your code goes here
end"
  end

  # PUT
  def update_one
"desc 'get #{resource}'
put do
  # your code goes here
end"
  end

  #
  # PUT/:id
  def update_specific
"desc 'get #{resource}'
put :id do
  # your code goes here
end"
  end

  # DELETE
  def delete_one
"desc 'get #{resource}'
delete do
  # your code goes here
end"
  end

  #
  # DELETE/:id
  def delete_specific
"desc 'get #{resource}'
delete :id do
  # your code goes here
end"
  end
end
