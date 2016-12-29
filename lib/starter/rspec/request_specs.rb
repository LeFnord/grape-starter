# frozen_string_literal: true

def route_from_description
  RSpec.current_example.metadata[:example_group][:parent_example_group][:description_args].first
end

RSpec.shared_examples 'POST' do |params: {}|
  let(:route) { route_from_description }

  subject { post route, params }
  specify { expect(subject.status).to eql 201 }
end

RSpec.shared_examples 'GET all' do
  let(:route) { route_from_description }

  subject { get route }
  specify { expect(subject.status).to eql 200 }
end

# singular forms
#
RSpec.shared_examples 'GET one' do
  let(:route) { route_from_description }

  subject { get route }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'PUT one' do |params: {}|
  let(:route) { route_from_description }

  subject { put route, params }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'PATCH one' do |params: {}|
  let(:route) { route_from_description }

  subject { patch route, params }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'DELETE one' do
  let(:route) { route_from_description }

  subject { delete route }
  specify { expect(subject.status).to eql 204 }
end

# plural forms
#
RSpec.shared_examples 'GET specific' do |key: nil|
  let(:route) { route_from_description }
  let(:specific_route) { "#{route}/#{key}" }

  subject { get specific_route }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'PUT specific' do |key: nil, params: {}|
  let(:route) { route_from_description }
  let(:specific_route) { "#{route}/#{key}" }

  subject { put specific_route, params }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'PATCH specific' do |key: nil, params: {}|
  let(:route) { route_from_description }
  let(:specific_route) { "#{route}/#{key}" }

  subject { patch specific_route, params }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'DELETE specific' do |key: nil|
  let(:route) { route_from_description }
  let(:specific_route) { "#{route}/#{key}" }

  subject { delete specific_route }
  specify { expect(subject.status).to eql 204 }
end
