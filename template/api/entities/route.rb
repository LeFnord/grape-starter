# frozen_string_literal: true

module Api
  module Entities
    class Route < Grape::Entity
      expose :verb,
             documentation: {
               type: String,
               desc: 'the http method of the route'
             }
      expose :path,
             documentation: {
               type: String,
               desc: 'the route itself'
             }
      expose :description,
             documentation: {
               type: String,
               desc: 'the route description'
             }
    end
  end
end
