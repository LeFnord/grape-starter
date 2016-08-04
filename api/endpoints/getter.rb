require 'grape-entity'
require 'entities/tool.rb'

module Starter
  module Endpoints
    class Getter < Grape::API
      desc 'Exposes an entity'
      namespace :entities do
        desc 'Expose a tool',
              params: ::Starter::Entities::Tool.documentation,
              success: ::Starter::Entities::Tool
        get ':key' do
          present OpenStruct.new(key: params[:key], length: 10, weight: '20kg'),
                  with: ::Starter::Entities::Tool,
                  foo: params[:foo]
        end
      end
    end
  end
end
