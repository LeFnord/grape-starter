# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Starter::Builder do
  let(:single) { 'foo' }
  let(:plural) { 'foos' }

  subject { described_class }

  specify { expect(subject).to respond_to :resource }
  specify { expect(subject).to respond_to :endpoints }

  describe 'Names methods' do
    subject { described_class.call! single }

    specify { expect(subject.send(:singular?)).to be true }
    specify { expect(subject.klass_name).to eql 'Foo' }
    specify { expect(subject.base_file_name).to eql 'foo.rb' }

    specify { expect(subject.api_file_name).to include 'api/endpoints/foo.rb' }
    specify { expect(subject.lib_file_name).to include 'lib/api/foo.rb' }
    specify { expect(subject.api_spec_name).to include 'spec/requests/foo_spec.rb' }
    specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo_spec.rb' }
  end

  describe '#endpoint_set' do
    let(:set) { subject.send(:endpoint_set) }

    describe 'CRUD methods' do
      describe 'plural' do
        subject { described_class.call! plural }
        let(:expected_set) do
          %i(
            post
            get_all
            get_specific
            put_specific
            patch_specific
            delete_specific
          )
        end
        specify { expect(set).to eql expected_set }
      end

      describe 'single' do
        subject { described_class.call! single }
        let(:expected_set) do
          %i(
            post
            get_one
            put_one
            patch_one
            delete_one
          )
        end
        specify { expect(set).to eql expected_set }
      end
    end

    describe 'methods specified' do
      describe 'POST' do
        describe 'single' do
          subject { described_class.call! single, set: ['post'] }
          specify { expect(set).to eql [:post] }
        end

        describe 'plural' do
          subject { described_class.call! plural, set: ['post'] }
          specify { expect(set).to eql [:post] }
        end
      end

      describe 'GET' do
        describe 'single' do
          subject { described_class.call! single, set: ['get'] }
          specify { expect(set).to eql [:get_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, set: ['get'] }
          specify { expect(set).to eql [:get_all, :get_specific] }
        end
      end

      describe 'PUT' do
        describe 'single' do
          subject { described_class.call! single, set: ['put'] }
          specify { expect(set).to eql [:put_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, set: ['put'] }
          specify { expect(set).to eql [:put_specific] }
        end
      end

      describe 'PATCH' do
        describe 'single' do
          subject { described_class.call! single, set: ['patch'] }
          specify { expect(set).to eql [:patch_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, set: ['patch'] }
          specify { expect(set).to eql [:patch_specific] }
        end
      end

      describe 'DELETE' do
        describe 'single' do
          subject { described_class.call! single, set: ['delete'] }
          specify { expect(set).to eql [:delete_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, set: ['delete'] }
          specify { expect(set).to eql [:delete_specific] }
        end
      end

      describe 'multinple given' do
        describe 'single' do
          subject { described_class.call! single, set: %w(post get delete) }
          specify { expect(set).to eql [:post, :get_one, :delete_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, set: %w(post get delete) }
          specify { expect(set).to eql [:post, :get_all, :get_specific, :delete_specific] }
        end
      end
    end
  end

  describe '#should_raise?' do
    let(:file) { '/file/path' }

    describe 'force false (default)' do
      subject { described_class.call! single, set: ['get'] }

      describe 'file not exist' do
        specify { expect { subject.send(:should_raise?, file) }.not_to raise_error }
      end

      describe 'file exist' do
        before(:each) { allow(File).to receive(:exist?).with(file).and_return true }

        specify { expect { subject.send(:should_raise?, file) }.to raise_error '… resource exists' }
      end
    end

    describe 'force true' do
      subject { described_class.call! single, set: ['get'], force: true }

      describe 'file not exist' do
        specify { expect { subject.send(:should_raise?, file) }.not_to raise_error }
      end

      describe 'file exist' do
        before(:each) { allow(File).to receive(:exist?).with(file).and_return true }

        specify { expect { subject.send(:should_raise?, file) }.not_to raise_error }
      end
    end
  end

  describe '#file_list' do
    describe 'standard' do
      subject { described_class.call! single }

      let(:files) { subject.send(:file_list) }
      specify do
        expect(files).to eql %w(api_file lib_file api_spec lib_spec)
      end
    end

    describe 'standard plus entity' do
      subject { described_class.call! single, entity: true }

      let(:files) { subject.send(:file_list) }
      specify do
        expect(files).to eql %w(api_file lib_file api_spec lib_spec entity_file)
      end
    end
  end
end
