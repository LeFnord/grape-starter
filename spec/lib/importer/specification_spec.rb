# frozen_string_literal: false

RSpec.describe Starter::Importer::Specification do
  describe '.new' do
    let(:spec) do
      JSON.load_file('./spec/fixtures/tictactoe.json', symbolize_names: true)
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
    end

    describe 'optional attributes' do
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

      describe 'invalid, if no one given' do
        let(:spec) { { openapi: '3.1.0', info: {} } }

        specify do
          expect { subject }.to raise_error Starter::Importer::Specification::Error
        end
      end
    end
  end
end
