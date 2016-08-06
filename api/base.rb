# FIXME: change Starter
module Api
  class Base < Grape::API
    version 'v1', using: :path
    format :json

    mount Endpoints::Root

    add_swagger_documentation format: :json,
                              info: {
                                title: 'Starter API'
                              },
                              models: [
                                Entities::ApiError
                              ]
  end
end
