# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Api::Rake::Builder do
  subject { described_class.build('foo') }

  specify do
    ap subject
    ap subject.singular?
    ap subject.klass_name
    ap subject.base_file_name
  end

  specify { expect(subject).to respond_to :klass_name }
  specify { expect(subject).to respond_to :base_file_name }
end
