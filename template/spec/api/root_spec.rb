# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Api::Base do
  include Rack::Test::Methods

  def app
    Api::Base
  end

  let(:exposed_keys) do
    [
      :verb,
      :path,
      :description
    ]
  end

  subject { get '/api/v1/root' }
  specify { expect(subject.status).to eql 200 }

  let(:response) { JSON.parse(subject.body, symbolize_names: true) }
  specify { expect(response.keys).to include :count, :items }

  let(:items) { response[:items] }
  specify 'has items with values' do
    items.each do |item|
      expect(item.keys).to include(*exposed_keys)
    end
  end
end
