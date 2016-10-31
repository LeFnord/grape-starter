# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Api::Rake::Names do
  subject { described_class }

  before do
    subject.instance_variable_set(:'@resource', resource)
  end

  describe 'plural forms' do
    describe 'foos' do
      let(:resource) { 'foos' }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foos' }
      specify { expect(subject.base_file_name).to eql 'foos.rb' }
    end

    describe 'foo_bars' do
      let(:resource) { 'foo_bars' }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'FooBars' }
      specify { expect(subject.base_file_name).to eql 'foo_bars.rb' }
    end

    describe 'foo-bars' do
      let(:resource) { 'foo-bars' }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foo::Bars' }
      specify { expect(subject.base_file_name).to eql 'foo-bars.rb' }
    end

    describe 'foo/bars' do
      let(:resource) { 'foo/bars' }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foo::Bars' }
      specify { expect(subject.base_file_name).to eql 'foo-bars.rb' }
    end
  end

  describe 'singular forms' do
    describe 'foo' do
      let(:resource) { 'foo' }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo' }
      specify { expect(subject.base_file_name).to eql 'foo.rb' }
    end

    describe 'foo_bar' do
      let(:resource) { 'foo_bar' }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'FooBar' }
      specify { expect(subject.base_file_name).to eql 'foo_bar.rb' }
    end

    describe 'foo-bar' do
      let(:resource) { 'foo-bar' }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo::Bar' }
      specify { expect(subject.base_file_name).to eql 'foo-bar.rb' }
    end

    describe 'foo/bar' do
      let(:resource) { 'foo/bar' }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo::Bar' }
      specify { expect(subject.base_file_name).to eql 'foo-bar.rb' }
    end
  end
end
