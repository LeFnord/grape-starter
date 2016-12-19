# frozen_string_literal: true
module Api
  class Base < Grape::API
    prefix :api
    version 'v1', using: :path
    format :json

    mount Endpoints::Root

    add_swagger_documentation format: :json,
                              info: {
                                title: 'Starter API'
                              },
                              mount_path: '/oapi',
                              models: [
                                Entities::ApiError
                              ]
  end
end
