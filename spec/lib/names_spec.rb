# frozen_string_literal: true

RSpec.describe Starter::Names do
  subject { described_class.new(resource) }

  describe 'child class of an ORM' do
    after(:each) do
      config_file = File.join(Dir.getwd, '.config')
      FileUtils.rm_f(config_file)
    end

    let(:resource) { 'foo' }
    specify { expect(subject.origin).to eql resource }

    describe 'orm option not given' do
      before { Starter::Config.save(content: { orm: 'some orm' }) }

      specify { expect(subject.lib_klass_name).to eql 'Foo' }
    end

    describe 'orm option is false' do
      before { subject.instance_variable_set(:@orm, false) }

      before { Starter::Config.save(content: { orm: 'some orm' }) }

      specify { expect(subject.lib_klass_name).to eql 'Foo' }
    end

    describe 'orm option is true' do
      before { subject.instance_variable_set(:@orm, true) }

      describe 'sets Sequel::Model' do
        before { Starter::Config.save(content: { orm: 'sequel' }) }

        specify { expect(subject.lib_klass_name).to eql 'Foo < Sequel::Model' }
      end
    end
  end

  describe 'plural forms' do
    describe 'foos' do
      let(:resource) { 'foos' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foos' }
      specify { expect(subject.resource_file).to eql 'foos.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foos.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foos.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foos_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foos_spec.rb' }
    end

    describe 'foo_bars' do
      let(:resource) { 'foo_bars' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'FooBars' }
      specify { expect(subject.resource_file).to eql 'foo_bars.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foo_bars.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foo_bars.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foo_bars_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foo_bars_spec.rb' }
    end

    describe 'foo-bars' do
      let(:resource) { 'foo-bars' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foo::Bars' }
      specify { expect(subject.resource_file).to eql 'foo-bars.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foo-bars.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foo-bars.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foo-bars_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foo-bars_spec.rb' }
    end

    describe 'foo/bars' do
      let(:resource) { 'foo/bars' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foo::Bars' }
      specify { expect(subject.resource_file).to eql 'foo-bars.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foo-bars.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foo-bars.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foo-bars_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foo-bars_spec.rb' }
    end
  end

  describe 'singular forms' do
    describe 'foo' do
      let(:resource) { 'foo' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo' }
      specify { expect(subject.resource_file).to eql 'foo.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foo.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foo.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foo_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foo_spec.rb' }
    end

    describe 'foo_bar' do
      let(:resource) { 'foo_bar' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'FooBar' }
      specify { expect(subject.resource_file).to eql 'foo_bar.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foo_bar.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foo_bar.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foo_bar_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foo_bar_spec.rb' }
    end

    describe 'foo-bar' do
      let(:resource) { 'foo-bar' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo::Bar' }
      specify { expect(subject.resource_file).to eql 'foo-bar.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foo-bar.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foo-bar.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foo-bar_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foo-bar_spec.rb' }
    end

    describe 'foo/bar' do
      let(:resource) { 'foo/bar' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo::Bar' }
      specify { expect(subject.resource_file).to eql 'foo-bar.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foo-bar.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foo-bar.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foo-bar_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foo-bar_spec.rb' }
    end
  end

  describe 'capitalized resource' do
    describe 'Foos' do
      let(:resource) { 'Foos' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be false }
      specify { expect(subject.klass_name).to eql 'Foos' }
      specify { expect(subject.resource_file).to eql 'foos.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foos.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foos.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foos_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foos_spec.rb' }
    end

    describe 'Foo' do
      let(:resource) { 'Foo' }
      specify { expect(subject.origin).to eql resource }
      specify { expect(subject.send(:singular?)).to be true }
      specify { expect(subject.klass_name).to eql 'Foo' }
      specify { expect(subject.resource_file).to eql 'foo.rb' }

      specify { expect(subject.api_file_name).to end_with '/api/endpoints/foo.rb' }
      specify { expect(subject.lib_file_name).to end_with '/lib/models/foo.rb' }
      specify { expect(subject.api_spec_name).to end_with '/spec/requests/foo_spec.rb' }
      specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/foo_spec.rb' }
    end
  end

  describe '2.0' do
    let(:resource) { '2.0' }
    specify { expect(subject.origin).to eql resource }
    specify { expect(subject.send(:singular?)).to be true }
    specify { expect(subject.klass_name).to eql 'B20' }
    specify { expect(subject.resource_file).to eql 'b_2_0.rb' }

    specify { expect(subject.api_file_name).to end_with '/api/endpoints/b_2_0.rb' }
    specify { expect(subject.lib_file_name).to end_with '/lib/models/b_2_0.rb' }
    specify { expect(subject.api_spec_name).to end_with '/spec/requests/b_2_0_spec.rb' }
    specify { expect(subject.lib_spec_name).to end_with '/spec/lib/models/b_2_0_spec.rb' }
  end
end
