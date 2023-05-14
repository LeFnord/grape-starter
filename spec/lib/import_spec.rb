# frozen_string_literal: false

RSpec.describe Starter::Import do
  describe '.do_it!' do
    let(:path) { './spec/fixtures/links.json' }

    subject { described_class.do_it!(path) }

    specify do
      subject
    end
  end

  describe '.load_spec' do
    subject { described_class.load_spec(path) }

    describe 'handles blank' do
      let(:path) { nil }

      specify do
        expect(subject).to be_nil
      end
    end

    describe 'loads json' do
      let(:path) { './spec/fixtures/tictactoe.json' }

      specify 'creates Spec object' do
        expect(subject).to be_a Starter::Importer::Specification
        expect(subject).to respond_to :openapi
        expect(subject.openapi).to be_a String
        expect(subject).to respond_to :info
        expect(subject.info).to be_a Hash
      end
    end

    describe 'loads yaml' do
      let(:path) { './spec/fixtures/tictactoe.yaml' }

      specify 'creates Spec object' do
        expect(subject).to be_a Starter::Importer::Specification
        expect(subject).to respond_to :openapi
        expect(subject.openapi).to be_a String
        expect(subject).to respond_to :info
        expect(subject.info).to be_a Hash
      end
    end
  end
end
