# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Starter::Config do
  before { subject.instance_variable_set(:@dest, Dir.getwd) }

  let(:config_file) { subject.config_file }
  let(:dest) { Dir.getwd }
  let(:content) { { orm: 'sequel' } }

  subject { described_class }

  it { is_expected.to respond_to :read }
  it { is_expected.to respond_to :save }

  describe 'SAVE' do
    after(:each) do
      FileUtils.rm(config_file) if File.exist?(config_file)
    end

    describe 'did not create a config file' do
      specify 'no argument' do
        FileUtils.rm(config_file) if File.exist?(config_file)
        subject.save
        expect(File.exist?(config_file)).to be false
      end

      specify 'nil given' do
        subject.save(content: nil)
        expect(File.exist?(config_file)).to be false
      end

      specify 'empty string given' do
        subject.save(content: '')
        expect(File.exist?(config_file)).to be false
      end

      specify 'empty hash given' do
        subject.save(content: {})
        expect(File.exist?(config_file)).to be false
      end
    end

    describe 'create config file' do
      specify do
        subject.save(content: content)
        expect(File.exist?(File.join(dest, '.config'))).to be true
        expect(subject.read).to eql content
      end

      describe 'append' do
        before do
          subject.save(content: content)
          subject.save(content: prefix)
        end

        describe 'nil' do
          let(:prefix) { nil }
          specify { expect(subject.read).to eql content }
        end

        describe 'not adding string' do
          let(:prefix) { 'foo' }
          specify { expect(subject.read).to eql content }
        end

        describe 'adds only Hashes' do
          let(:prefix) { { bar: 'foo' } }
          specify { expect(subject.read).to eql content.merge(prefix) }
        end
      end
    end

    describe 'READ' do
      after(:each) do
        FileUtils.rm(config_file) if File.exist?(config_file)
      end

      let(:return_value) { subject.read }

      describe 'returns empty hash, if not exist' do
        before { FileUtils.rm(config_file) if File.exist?(config_file) }
        specify do
          expect(return_value).to eql({})
        end
      end

      describe 'returns a ruby object' do
        before do
          subject.save(content: content)
        end

        specify do
          expect(return_value).to eql content
        end
      end

      describe 'append data' do
        let(:new_data) { { bar: 'foo' } }

        before do
          subject.save(content: content)
          subject.save(content: new_data)
        end

        specify do
          expect(return_value).to eql content.merge(new_data)
        end
      end
    end
  end
end
