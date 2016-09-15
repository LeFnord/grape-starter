require 'spec_helper'

RSpec.describe Api::Rake::Builder do
  subject { described_class.build('foo-bar') }

  specify do
    p subject.resource_file
    p subject.resource_class
    p subject.resource_namespace
    p subject.mount_in_base
    p subject.lib_file
  end

  specify { expect(subject.resource_file).not_to be_nil }
  specify { expect(subject.resource_class).not_to be_nil }
  specify { expect(subject.resource_namespace).not_to be_nil }
  specify { expect(subject.mount_in_base).not_to be_nil }
  specify { expect(subject.lib_file).not_to be_nil }
end
