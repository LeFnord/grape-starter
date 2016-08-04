require 'spec_helper'

RSpec.describe Starter::Base do
  include Rack::Test::Methods

  def app
    Starter::Base
  end

  subject(:swagger) do
    get '/api/v1/swagger_doc'
    last_response
  end

  specify { expect(swagger.status).to eql 200 }
  specify { expect(swagger.body).not_to be_empty }

  let(:swagger_doc) { JSON.parse(swagger.body, symbolize_names: true) }
  specify do
    expect(swagger_doc[:info][:version]).to eql Starter::VERSION
  end
end
