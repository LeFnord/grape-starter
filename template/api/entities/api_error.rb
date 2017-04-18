# frozen_string_literal: true

module Api
  module Entities
    class ApiError < Grape::Entity
      expose :code,
             documentation: {
               type: Integer,
               desc: 'the http status code'
             }
      expose :message,
             documentation: {
               type: String,
               desc: 'the error message'
             }
    end
  end
end
