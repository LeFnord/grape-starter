require 'spec_helper'

RSpec.describe Starter::Rake::GrapeTasks do
  subject { described_class.new }

  describe '#api_routes' do
    let(:route_keys) { [:verb, :path, :description] }
    let(:api_routes) { subject.api_routes }

    specify { expect(api_routes).to be_a Array }

    let(:route) { api_routes.first }
    specify { expect(route.keys.sort).to eql route_keys.sort }
  end
end
