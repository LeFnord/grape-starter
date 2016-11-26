# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Starter::Names do
  subject { Starter::Builder.call!(resource) }

  describe 'plural forms' do
    describe 'foos' do
      let(:resource) { 'foos' }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foos' }
      specify { expect(subject.base_file_name).to eql 'foos.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foos.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foos.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foos_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foos_spec.rb' }
    end

    describe 'foo_bars' do
      let(:resource) { 'foo_bars' }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'FooBars' }
      specify { expect(subject.base_file_name).to eql 'foo_bars.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foo_bars.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foo_bars.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo_bars_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo_bars_spec.rb' }
    end

    describe 'foo-bars' do
      let(:resource) { 'foo-bars' }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foo::Bars' }
      specify { expect(subject.base_file_name).to eql 'foo-bars.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foo-bars.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foo-bars.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo-bars_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo-bars_spec.rb' }
    end

    describe 'foo/bars' do
      let(:resource) { 'foo/bars' }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foo::Bars' }
      specify { expect(subject.base_file_name).to eql 'foo-bars.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foo-bars.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foo-bars.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo-bars_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo-bars_spec.rb' }
    end
  end

  describe 'singular forms' do
    describe 'foo' do
      let(:resource) { 'foo' }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo' }
      specify { expect(subject.base_file_name).to eql 'foo.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foo.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foo.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo_spec.rb' }
    end

    describe 'foo_bar' do
      let(:resource) { 'foo_bar' }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'FooBar' }
      specify { expect(subject.base_file_name).to eql 'foo_bar.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foo_bar.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foo_bar.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo_bar_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo_bar_spec.rb' }
    end

    describe 'foo-bar' do
      let(:resource) { 'foo-bar' }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo::Bar' }
      specify { expect(subject.base_file_name).to eql 'foo-bar.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foo-bar.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foo-bar.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo-bar_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo-bar_spec.rb' }
    end

    describe 'foo/bar' do
      let(:resource) { 'foo/bar' }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo::Bar' }
      specify { expect(subject.base_file_name).to eql 'foo-bar.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foo-bar.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foo-bar.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo-bar_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo-bar_spec.rb' }
    end
  end

  describe 'capitalized resource' do
    describe 'Foos' do
      let(:resource) { 'Foos' }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foos' }
      specify { expect(subject.base_file_name).to eql 'foos.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foos.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foos.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foos_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foos_spec.rb' }
    end

    describe 'Foo' do
      let(:resource) { 'Foo' }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo' }
      specify { expect(subject.base_file_name).to eql 'foo.rb' }

      specify { expect(subject.api_file_name).to include 'api/endpoints/foo.rb' }
      specify { expect(subject.lib_file_name).to include 'lib/api/foo.rb' }
      specify { expect(subject.api_spec_name).to include 'spec/api/endpoints/foo_spec.rb' }
      specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo_spec.rb' }
    end
  end
end
