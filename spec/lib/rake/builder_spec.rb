# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Api::Rake::Builder do
  subject { described_class.build('foo') }

  specify do
    # ap subject.resource_file
    # ap "\n"
    # ap subject.resource_lib
  end

  specify { expect(subject).to respond_to :'singular?' }
  specify { expect(subject).to respond_to :klass_name }
  specify { expect(subject).to respond_to :base_file_name }
  specify { expect(subject).to respond_to :resource }
  specify { expect(subject).to respond_to :endpoints }

  specify { expect(subject.endpoints).to be_a String }
end
