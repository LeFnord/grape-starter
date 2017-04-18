# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '/{{{grape-starter}}}/v1/oapi' do
  subject(:swagger) do
    get RSpec.current_example.metadata[:example_group][:full_description]
    last_response
  end

  specify { expect(swagger.status).to eql 200 }
  specify { expect(swagger.body).not_to be_empty }
end
