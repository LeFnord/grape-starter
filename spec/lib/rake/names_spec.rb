require 'spec_helper'

RSpec.describe Api::Rake::Names do
  subject { described_class }

  before do
    subject.instance_variable_set(:'@resource', resource)
  end

  describe 'plural forms' do
    describe 'foos' do
      let(:resource) { 'foos' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foos' }
      specify { expect(subject.resource_class).to eql 'Foos' }
      specify { expect(subject.resource_namespace).to eql [:foos] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::Foos' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foos' }
    end

    describe 'foo_bars' do
      let(:resource) { 'foo_bars' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo_bars' }
      specify { expect(subject.resource_class).to eql 'FooBars' }
      specify { expect(subject.resource_namespace).to eql [:foo_bars] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::FooBars' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo_bars' }
    end

    describe 'foo/bars' do
      let(:resource) { 'foo/bars' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo/bars' }
      specify { expect(subject.resource_class).to eql 'Foo::Bars' }
      specify { expect(subject.resource_namespace).to eql [:foo, :bars] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::Foo::Bars' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo/bars' }
    end

    describe 'Foos' do
      let(:resource) { 'Foos' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foos' }
      specify { expect(subject.resource_class).to eql 'Foos' }
      specify { expect(subject.resource_namespace).to eql [:foos] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::Foos' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foos' }
    end

    describe 'FooBars' do
      let(:resource) { 'FooBars' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo_bars' }
      specify { expect(subject.resource_class).to eql 'FooBars' }
      specify { expect(subject.resource_namespace).to eql [:foo_bars] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::FooBars' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo_bars' }
    end

    describe 'Foo::Bars' do
      let(:resource) { 'Foo::bars' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo/bars' }
      specify { expect(subject.resource_class).to eql 'Foo::Bars' }
      specify { expect(subject.resource_namespace).to eql [:foo, :bars] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::Foo::Bars' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo/bars' }
    end
  end

  describe 'singular forms' do
    describe 'foo' do
      let(:resource) { 'foo' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo' }
      specify { expect(subject.resource_class).to eql 'Foo' }
      specify { expect(subject.resource_namespace).to eql [:foo] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::Foo' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo' }
    end

    describe 'foo_bar' do
      let(:resource) { 'foo_bar' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo_bar' }
      specify { expect(subject.resource_class).to eql 'FooBar' }
      specify { expect(subject.resource_namespace).to eql [:foo_bar] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::FooBar' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo_bar' }
    end

    describe 'foo/bar' do
      let(:resource) { 'foo/bar' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo/bar' }
      specify { expect(subject.resource_class).to eql 'Foo::Bar' }
      specify { expect(subject.resource_namespace).to eql [:foo, :bar] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::Foo::Bar' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo/bar' }
    end

    describe 'Foo' do
      let(:resource) { 'Foo' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo' }
      specify { expect(subject.resource_class).to eql 'Foo' }
      specify { expect(subject.resource_namespace).to eql [:foo] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::Foo' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo' }
    end

    describe 'FooBar' do
      let(:resource) { 'FooBar' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo_bar' }
      specify { expect(subject.resource_class).to eql 'FooBar' }
      specify { expect(subject.resource_namespace).to eql [:foo_bar] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::FooBar' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo_bar' }
    end

    describe 'Foo::Bar' do
      let(:resource) { 'Foo::Bar' }
      specify { expect(subject.resource_file).to eql 'api/endpoints/foo/bar' }
      specify { expect(subject.resource_class).to eql 'Foo::Bar' }
      specify { expect(subject.resource_namespace).to eql [:foo, :bar] }
      specify { expect(subject.mount_in_base).to eql 'mount Api::Endpoints::Foo::Bar' }
      specify { expect(subject.lib_file).to eql 'lib/api/endpoints/foo/bar' }
    end
  end
end
