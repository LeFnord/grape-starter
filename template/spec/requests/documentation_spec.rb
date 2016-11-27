# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Api::Base do
  subject(:swagger) do
    get '/api/v1/swagger_doc'
    last_response
  end

  specify { expect(swagger.status).to eql 200 }
  specify { expect(swagger.body).not_to be_empty }
end
