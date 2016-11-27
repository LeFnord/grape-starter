# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Starter::Builder do
  subject { described_class }

  specify do
    # require 'pry'; binding.pry
    # print subject.api_file
    # print "\n"
    # print subject.lib_file
  end

  specify { expect(subject).to respond_to :resource }
  specify { expect(subject).to respond_to :endpoints }

  describe 'Names methods' do
    subject { described_class.call!('foo') }

    specify { expect(subject.send(:singular?)).to be true }
    specify { expect(subject.klass_name).to eql 'Foo' }
    specify { expect(subject.base_file_name).to eql 'foo.rb' }

    specify { expect(subject.api_file_name).to include 'api/endpoints/foo.rb' }
    specify { expect(subject.lib_file_name).to include 'lib/api/foo.rb' }
    specify { expect(subject.api_spec_name).to include 'spec/requests/foo_spec.rb' }
    specify { expect(subject.lib_spec_name).to include 'spec/lib/api/foo_spec.rb' }
  end

  describe '#endpoint_set' do
    let(:single) { 'foo' }
    let(:plural) { 'foos' }
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
          subject { described_class.call! single, ['post'] }
          specify { expect(set).to eql [:post] }
        end

        describe 'plural' do
          subject { described_class.call! plural, ['post'] }
          specify { expect(set).to eql [:post] }
        end
      end

      describe 'GET' do
        describe 'single' do
          subject { described_class.call! single, ['get'] }
          specify { expect(set).to eql [:get_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, ['get'] }
          specify { expect(set).to eql [:get_all, :get_specific] }
        end
      end

      describe 'PUT' do
        describe 'single' do
          subject { described_class.call! single, ['put'] }
          specify { expect(set).to eql [:put_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, ['put'] }
          specify { expect(set).to eql [:put_specific] }
        end
      end

      describe 'PATCH' do
        describe 'single' do
          subject { described_class.call! single, ['patch'] }
          specify { expect(set).to eql [:patch_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, ['patch'] }
          specify { expect(set).to eql [:patch_specific] }
        end
      end

      describe 'DELETE' do
        describe 'single' do
          subject { described_class.call! single, ['delete'] }
          specify { expect(set).to eql [:delete_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, ['delete'] }
          specify { expect(set).to eql [:delete_specific] }
        end
      end

      describe 'multinple given' do
        describe 'single' do
          subject { described_class.call! single, %w(post get delete) }
          specify { expect(set).to eql [:post, :get_one, :delete_one] }
        end

        describe 'plural' do
          subject { described_class.call! plural, %w(post get delete) }
          specify { expect(set).to eql [:post, :get_all, :get_specific, :delete_specific] }
        end
      end
    end
  end
end
