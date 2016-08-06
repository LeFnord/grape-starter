require 'spec_helper'

RSpec.describe Api::Base do
  include Rack::Test::Methods

  def app
    Api::Base
  end

  subject(:swagger) do
    get '/v1/swagger_doc'
    last_response
  end

  specify { expect(swagger.status).to eql 200 }
  specify { expect(swagger.body).not_to be_empty }
end
