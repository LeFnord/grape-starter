# frozen_string_literal: false
require 'spec_helper'

RSpec.describe Starter::Builder do
  let(:single) { 'foo' }
  let(:plural) { 'foos' }

  subject { described_class }

  specify { expect(subject).to respond_to :resource }
  specify { expect(subject).to respond_to :set }
  specify { expect(subject).to respond_to :force }
  specify { expect(subject).to respond_to :entity }
  specify { expect(subject).to respond_to :destination }

  describe 'public methods' do
    it { is_expected.to respond_to :new! }
    it { is_expected.to respond_to :add! }
    it { is_expected.to respond_to :remove! }
  end

  describe 'Names methods' do
    subject { described_class.add! single }

    specify { expect(subject.send(:singular?)).to be true }
    specify { expect(subject.klass_name).to eql 'Foo' }
    specify { expect(subject.base_file_name).to eql 'foo.rb' }

    specify { expect(subject.api_file_name).to include 'api/endpoints/foo.rb' }
    specify { expect(subject.lib_file_name).to include 'lib/api/foo.rb' }
    specify { expect(subject.api_spec_name).to include 'spec/requests/foo_spec.rb' }
    specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo_spec.rb' }
  end

  describe '#file_list' do
    describe 'standard' do
      subject { described_class.add! single }

      let(:files) { subject.send(:file_list) }
      specify do
        expect(files).to eql %w(api_file lib_file api_spec lib_spec)
      end
    end

    describe 'standard plus entity' do
      subject { described_class.add! single, entity: true }

      let(:files) { subject.send(:file_list) }
      specify do
        expect(files).to eql %w(api_file lib_file api_spec lib_spec entity_file)
      end
    end
  end

  describe '#should_raise?' do
    let(:file) { '/file/path' }

    describe 'force false (default)' do
      subject { described_class.add! single, set: ['get'] }

      describe 'file not exist' do
        specify { expect { subject.send(:should_raise?, file) }.not_to raise_error }
      end

      describe 'file exist' do
        before(:each) { allow(File).to receive(:exist?).with(file).and_return true }

        specify { expect { subject.send(:should_raise?, file) }.to raise_error '… resource exists' }
      end
    end

    describe 'force true' do
      subject { described_class.add! single, set: ['get'], force: true }

      describe 'file not exist' do
        specify { expect { subject.send(:should_raise?, file) }.not_to raise_error }
      end

      describe 'file exist' do
        before(:each) { allow(File).to receive(:exist?).with(file).and_return true }

        specify { expect { subject.send(:should_raise?, file) }.not_to raise_error }
      end
    end
  end

  describe 'manipulating API Base file' do
    let!(:created_api) { File.join(Dir.getwd, subject.destination) }
    let(:base) { File.read(File.join(created_api, 'api', 'base.rb')) }
    subject do
      starter_gem = Gem::Specification.find_by_name('grape-starter').gem_dir
      src = File.join(starter_gem, 'template', '.')
      described_class.new!(plural, src, plural)
    end

    after :each do
      FileUtils.remove_dir(created_api, true)
    end

    describe 'set prefix on `new`' do
      let(:expected_prefix) { "prefix :#{subject.resource}" }
      specify do
        expect(base).to include expected_prefix
      end
    end

    describe 'add|remove mount_point' do
      before do
        allow(subject).to receive(:klass_name).and_return('bar')
      end

      let(:base_without_resource) do
        "
        # frozen_string_literal: true
        module Api
          class Base < Grape::API
            prefix :api
            version 'v1', using: :path
            format :json

            mount Endpoints::Root
            add_swagger_documentation format: :json,
                                      info: {
                                        title: 'Starter API'
                                      },
                                      models: [
                                        Entities::ApiError
                                      ]
          end
        end
        "
      end

      let(:base_with_resource) do
        "
        # frozen_string_literal: true
        module Api
          class Base < Grape::API
            prefix :api
            version 'v1', using: :path
            format :json

            mount Endpoints::Root
            mount Endpoints::#{subject.klass_name}
            add_swagger_documentation format: :json,
                                      info: {
                                        title: 'Starter API'
                                      },
                                      models: [
                                        Entities::ApiError
                                      ]
          end
        end
        "
      end

      describe '#add_to_base' do
        specify do
          expect(subject.send(:add_to_base, base_without_resource)).to include subject.mount_point
        end
      end

      describe '#remove_from_base' do
        specify do
          expect(subject.send(:remove_from_base, base_with_resource)).not_to include subject.mount_point
        end
      end
    end
  end

  describe '#endpoint_set' do
    let(:set) { subject.send(:endpoint_set) }

    describe 'CRUD methods' do
      describe 'plural' do
        subject { described_class.add! plural }
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
        subject { described_class.add! single }
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
          subject { described_class.add! single, set: ['post'] }
          specify { expect(set).to eql [:post] }
        end

        describe 'plural' do
          subject { described_class.add! plural, set: ['post'] }
          specify { expect(set).to eql [:post] }
        end
      end

      describe 'GET' do
        describe 'single' do
          subject { described_class.add! single, set: ['get'] }
          specify { expect(set).to eql [:get_one] }
        end

        describe 'plural' do
          subject { described_class.add! plural, set: ['get'] }
          specify { expect(set).to eql [:get_all, :get_specific] }
        end
      end

      describe 'PUT' do
        describe 'single' do
          subject { described_class.add! single, set: ['put'] }
          specify { expect(set).to eql [:put_one] }
        end

        describe 'plural' do
          subject { described_class.add! plural, set: ['put'] }
          specify { expect(set).to eql [:put_specific] }
        end
      end

      describe 'PATCH' do
        describe 'single' do
          subject { described_class.add! single, set: ['patch'] }
          specify { expect(set).to eql [:patch_one] }
        end

        describe 'plural' do
          subject { described_class.add! plural, set: ['patch'] }
          specify { expect(set).to eql [:patch_specific] }
        end
      end

      describe 'DELETE' do
        describe 'single' do
          subject { described_class.add! single, set: ['delete'] }
          specify { expect(set).to eql [:delete_one] }
        end

        describe 'plural' do
          subject { described_class.add! plural, set: ['delete'] }
          specify { expect(set).to eql [:delete_specific] }
        end
      end

      describe 'multinple given' do
        describe 'single' do
          subject { described_class.add! single, set: %w(post get delete) }
          specify { expect(set).to eql [:post, :get_one, :delete_one] }
        end

        describe 'plural' do
          subject { described_class.add! plural, set: %w(post get delete) }
          specify { expect(set).to eql [:post, :get_all, :get_specific, :delete_specific] }
        end
      end
    end
  end
end
