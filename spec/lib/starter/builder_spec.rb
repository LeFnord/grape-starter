# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Starter::Builder do
  subject { described_class }

  specify do
    # require 'pry'; binding.pry
    # print subject.api_file
    # print "\n"
    # print subject.lib_file
  end

  specify { expect(subject).to respond_to :resource }
  specify { expect(subject).to respond_to :endpoints }

  describe 'Names methods' do
    subject { described_class.call!('foo') }

    specify { expect(subject.send(:singular?)).to be true }
    specify { expect(subject.klass_name).to eql 'Foo' }
    specify { expect(subject.base_file_name).to eql 'foo.rb' }

    specify { expect(subject.api_file_name).to include 'api/endpoints/foo.rb' }
    specify { expect(subject.lib_file_name).to include 'lib/api/foo.rb' }
    specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo_spec.rb' }
    specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo_spec.rb' }
  end

  describe '#endpoint_set' do
    let(:set) { subject.send(:endpoint_set) }

    describe 'plural CRUD' do
      subject { described_class.call!('foos') }
      let(:expected_set) do
        %i(
          create
          get_all
          get_specific
          put_specific
          delete_specific
        )
      end
      specify { expect(set).to eql expected_set }
    end

    describe 'sungle CRUD' do
      subject { described_class.call!('foo') }
      let(:expected_set) do
        %i(
          create
          get_one
          put_one
          delete_one
        )
      end
      specify { expect(set).to eql expected_set }
    end
  end
end
