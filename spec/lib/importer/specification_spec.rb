# frozen_string_literal: false

RSpec.describe Starter::Importer::Specification do
  include_context 'specification'

  describe '.new' do
    let(:spec) do
      JSON.load_file('./spec/fixtures/tictactoe.json')
    end

    subject { described_class.new(spec) }

    describe 'mandatory attributes' do
      specify do
        expect(subject).to respond_to :openapi
        expect(subject.openapi).to be_a String
      end

      specify do
        expect(subject).to respond_to :info
        expect(subject.info).to be_a Hash
      end
    end

    describe 'invalid, missing info' do
      let(:spec) { { openapi: '3.1.0' } }

      specify do
        expect { subject }.to raise_error KeyError
      end
    end

    describe 'invalid, missing openapi' do
      let(:spec) { { info: {} } }

      specify do
        expect { subject }.to raise_error KeyError
      end
    end

    describe 'optional attributes' do
      describe 'paths must be given' do
        let(:spec) do
          tmp = default_specification.except(:paths)
          tmp[:components] = {}
          tmp.deep_stringify_keys
        end

        specify do
          expect { subject }.to raise_error KeyError, 'key not found: "paths"'
        end
      end

      specify do
        expect(subject).to respond_to :paths
        expect(subject.paths).to be_a Hash
      end
      specify do
        expect(subject).to respond_to :components
        expect(subject.components).to be_a Hash
      end
      specify do
        expect(subject).to respond_to :webhooks
        expect(subject.webhooks).to be_falsey
      end
    end
  end

  describe '#namespaces' do
    subject { described_class.new(spec).namespaces }

    describe 'paths empty -> valid, but senseless' do
      let(:spec) do
        default_specification.deep_stringify_keys
      end

      specify do
        expect { subject }.to raise_error Starter::Importer::Specification::Error
      end
    end

    describe '`/` -> raises missing endpoint error' do
      let(:spec) do
        default_specification[:paths] = { '/' => {} }
        default_specification.deep_stringify_keys
      end

      specify do
        expect { subject }.to raise_error Starter::Importer::Specification::Error
      end
    end

    describe '`/{template}` -> not allowed, because of ambiguity' do
      let(:spec) do
        default_specification[:paths] = { '/' => {}, '/{}' => {} }
        default_specification.deep_stringify_keys
      end

      specify do
        expect { subject }.to raise_error Starter::Importer::Specification::Error
      end
    end

    describe '`/`+`/endpoint` -> slash will be ignored' do
      let(:spec) do
        default_specification[:paths] = { '/' => {}, '/a' => {} }
        default_specification.deep_stringify_keys
      end

      specify do
        expect(subject).to eql('a' => { '/' => {} })
      end
    end

    describe 'multiple endpoints' do
      let(:spec) do
        default_specification[:paths] = { '/' => {}, '/a/{c}' => {}, '/b' => {}, '/a' => {} }
        default_specification.deep_stringify_keys
      end

      specify do
        expect(subject).to eql(
          {
            'a' => { '/' => {}, '/{c}' => {} },
            'b' => { '/' => {} }
          }
        )
      end
    end

    describe 'unusual endpoints' do
      let(:spec) do
        default_specification[:paths] = { '/' => {}, '/2.0/{c}' => {}, '/a-c' => {}, '/2.0/u' => {} }
        default_specification.deep_stringify_keys
      end

      specify do
        expect(subject).to eql(
          {
            '2.0' => { '/u' => {}, '/{c}' => {} },
            'a-c' => { '/' => {} }
          }
        )
      end
    end
  end
end
