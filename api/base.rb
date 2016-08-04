# FIXME: change Starter
module Starter
  class Base < Grape::API
    version 'v1', using: :path
    prefix 'api'
    format :json

    mount ::Starter::Endpoints::Getter

    add_swagger_documentation format: :json,
                              doc_version: Starter::VERSION,
                              info: {
                                title: 'Starter API'
                              }
  end
end
