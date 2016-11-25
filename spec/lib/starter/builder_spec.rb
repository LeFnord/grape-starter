# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Starter::Builder do
  subject { described_class.build('foo') }

  specify do
    # require 'pry'; binding.pry
    # print subject.api_file
    # print "\n"
    # print subject.lib_file
  end

  specify { expect(subject).to respond_to :resource }
  specify { expect(subject).to respond_to :endpoints }

  specify { expect(subject.endpoints).to be_a String }

  describe 'Names methods' do
    specify { expect(subject.send(:singular?)).to be true }
    specify { expect(subject.klass_name).to eql 'Foo' }
    specify { expect(subject.base_file_name).to eql 'foo.rb' }

    specify { expect(subject.api_file_name).to include 'api/endpoints/foo.rb' }
    specify { expect(subject.lib_file_name).to include 'lib/api/foo.rb' }
    specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo_spec.rb' }
    specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo_spec.rb' }
  end
end
