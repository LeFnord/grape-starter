# frozen_string_literal: true

RSpec.describe Starter::Rake::GrapeTasks do
  let(:app) do
    Class.new(Grape::API) do
      get do
        { foo: 'that is the response' }
      end
    end
  end

  subject { described_class.new(app) }

  describe '#api_routes' do
    let(:route_keys) { %i[verb path description] }
    let(:api_routes) { subject.api_routes }

    specify { expect(api_routes).to be_a Array }

    let(:route) { api_routes.first }
    specify { expect(route.keys.sort).to eql route_keys.sort }
  end
end
