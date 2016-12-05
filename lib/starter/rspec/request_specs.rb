# frozen_string_literal: true

# CRUD examples
#
# for single
RSpec.shared_examples 'single CRUD' do |base_path: '/api/v1', resource: ''|
  it_behaves_like 'POST', base_path: base_path, resource: resource
  it_behaves_like 'GET one', base_path: base_path, resource: resource
  it_behaves_like 'PUT one', base_path: base_path, resource: resource
  it_behaves_like 'PATCH one', base_path: base_path, resource: resource
  it_behaves_like 'DELETE one', base_path: base_path, resource: resource
end
#
# for plural
RSpec.shared_examples 'plural CRUD' do |base_path: '/api/v1', resource: '', key: nil|
  it_behaves_like 'POST', base_path: base_path, resource: resource
  it_behaves_like 'GET all', base_path: base_path, resource: resource
  it_behaves_like 'GET specific', base_path: base_path, resource: resource, key: key
  it_behaves_like 'PUT specific', base_path: base_path, resource: resource, key: key
  it_behaves_like 'PATCH specific', base_path: base_path, resource: resource, key: key
  it_behaves_like 'DELETE specific', base_path: base_path, resource: resource, key: key
end

RSpec.shared_examples 'POST' do |base_path: '/api/v1', resource: ''|
  let(:route) { "#{base_path}/#{resource}" }

  subject { post route }
  specify { expect(subject.status).to eql 201 }
end

RSpec.shared_examples 'GET all' do |base_path: '/api/v1', resource: ''|
  let(:route) { "#{base_path}/#{resource}" }

  subject { get route }
  specify { expect(subject.status).to eql 200 }
end

# singular forms
#
RSpec.shared_examples 'GET one' do |base_path: '/api/v1', resource: ''|
  let(:route) { "#{base_path}/#{resource}" }

  subject { get route }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'PUT one' do |base_path: '/api/v1', resource: ''|
  let(:route) { "#{base_path}/#{resource}" }

  subject { put route }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'PATCH one' do |base_path: '/api/v1', resource: ''|
  let(:route) { "#{base_path}/#{resource}" }

  subject { patch route }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'DELETE one' do |base_path: '/api/v1', resource: ''|
  let(:route) { "#{base_path}/#{resource}" }

  subject { delete route }
  specify { expect(subject.status).to eql 204 }
end

# plural forms
#
RSpec.shared_examples 'GET specific' do |base_path: '/api/v1', resource: '', key: nil|
  let(:route) { "#{base_path}/#{resource}" }
  let(:specific_route) { "#{route}/#{key}" }

  subject { get specific_route }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'PUT specific' do |base_path: '/api/v1', resource: '', key: nil|
  let(:route) { "#{base_path}/#{resource}" }
  let(:specific_route) { "#{route}/#{key}" }

  subject { put specific_route }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'PATCH specific' do |base_path: '/api/v1', resource: '', key: nil|
  let(:route) { "#{base_path}/#{resource}" }
  let(:specific_route) { "#{route}/#{key}" }

  subject { patch specific_route }
  specify { expect(subject.status).to eql 200 }
end

RSpec.shared_examples 'DELETE specific' do |base_path: '/api/v1', resource: '', key: nil|
  let(:route) { "#{base_path}/#{resource}" }
  let(:specific_route) { "#{route}/#{key}" }

  subject { delete specific_route }
  specify { expect(subject.status).to eql 204 }
end
