# frozen_string_literal: false

RSpec.describe Starter::Importer::Specification do
  include_context 'specification'

  describe '.new' do
    let(:spec) do
      JSON.load_file('./spec/fixtures/tictactoe.json')
    end

    subject { described_class.new(spec:) }

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
    subject { described_class.new(spec:).namespaces }

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
        default_specification[:paths] = { '/' => {}, '/u/{c}' => {}, '/a-c' => {}, '/u' => {} }
        default_specification.deep_stringify_keys
      end

      specify do
        expect(subject).to eql(
          {
            'u' => { '/' => {}, '/{c}' => {} },
            'a-c' => { '/' => {} }
          }
        )
      end
    end

    describe 'ignores possible versioning' do
      let(:spec) do
        default_specification[:paths] = {
          '/' => {},
          '/2.0/a' => {},
          '/2.0/a/{c}' => {},
          '/v3/b' => {},
          '/v3/b/{c}' => {},
          '/api/v3/c' => {},
          '/api/v3/c/{c}' => {},
          '/api/v3.1/d' => {},
          '/api/v3.1/d/{c}' => {}
        }
        default_specification.deep_stringify_keys
      end

      specify do
        expect(subject).to eql(
          {
            'a' => { '/' => {}, '/{c}' => {} },
            'b' => { '/' => {}, '/{c}' => {} },
            'c' => { '/' => {}, '/{c}' => {} },
            'd' => { '/' => {}, '/{c}' => {} }
          }
        )
      end
    end
  end

  describe '#segmentizen' do
    let(:spec) do
      default_specification.deep_stringify_keys
    end

    subject { described_class.new(spec:).send(:segmentize, path) }

    describe '/2.0/a' do
      let(:path) { '/2.0/a' }
      specify do
        expect(subject).to match_array ['a', '/']
      end
    end

    describe '/2.0/a/{c}' do
      let(:path) { '/2.0/a/{c}' }
      specify do
        expect(subject).to match_array ['a', '/{c}']
      end
    end

    describe '/v3/b' do
      let(:path) { '/v3/b' }
      specify do
        expect(subject).to match_array ['b', '/']
      end
    end

    describe '/v3/b/{c}' do
      let(:path) { '/v3/b/{c}' }
      specify do
        expect(subject).to match_array ['b', '/{c}']
      end
    end

    describe '/api/v3/c' do
      let(:path) { '/api/v3/c' }
      specify do
        expect(subject).to match_array ['c', '/']
      end
    end

    describe '/api/v3/c/{c}' do
      let(:path) { '/api/v3/c/{c}' }
      specify do
        expect(subject).to match_array ['c', '/{c}']
      end
    end

    describe '/api/v3.1/c' do
      let(:path) { '/api/v3/c' }
      specify do
        expect(subject).to match_array ['c', '/']
      end
    end

    describe '/api/v3.1/c/{c}' do
      let(:path) { '/api/v3/c/{c}' }
      specify do
        expect(subject).to match_array ['c', '/{c}']
      end
    end
  end
end
