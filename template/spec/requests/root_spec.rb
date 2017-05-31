# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '{{{grape-starter}}}/v1/root' do
  let(:exposed_keys) do
    %i[
      verb
      path
      description
    ]
  end

  subject { get RSpec.current_example.metadata[:example_group][:full_description] }
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
