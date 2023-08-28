# frozen_string_literal: false

RSpec.describe Starter::Importer::Parameter do
  describe 'valid parameters -sets kind' do
    describe 'name in definition' do
      subject { described_class.new(definition:) }

      let(:definition) { { 'name' => 'limit' } }

      specify do
        expect { subject }.not_to raise_error
        expect(subject.kind).to eql :direct
      end
    end

    describe 'ref and components/parameters given' do
      subject { described_class.new(definition:, components:) }

      let(:definition) { { '$ref' => '#/components/parameters/rowParam' } }

      let(:components) { { 'parameters' => { 'rowParam' => {} } } }

      specify do
        expect { subject }.not_to raise_error
        expect(subject.kind).to eql :ref
      end
    end
  end

  describe 'invalid parameters' do
    describe 'no name nor ref given' do
      subject { described_class.new(definition:) }

      let(:definition) { {} }

      specify do
        expect { subject }.to raise_error Starter::Importer::Parameter::Error
      end
    end

    describe 'ref given, but without component part' do
      subject { described_class.new(definition:, components:) }

      let(:definition) { { '$ref' => '#/components/parameters/rowParam' } }
      let(:components) { {} }

      specify do
        expect { subject }.to raise_error Starter::Importer::Parameter::Error
      end
    end
  end

  describe 'local params' do
    subject { described_class.new(definition:) }

    describe 'atomic' do
      let(:definition) do
        {
          'name' => 'limit',
          'in' => 'query',
          'description' => 'maximum number of results to return',
          'required' => false,
          'schema' => { 'type' => 'integer', 'format' => 'int32' }
        }
      end

      specify do
        expect(subject.name).to eql 'limit'
        expect(subject.definition.keys).to match_array %w[
          description in required schema
        ]
      end
    end

    describe 'array' do
      let(:definition) do
        {
          'name' => 'tags',
          'in' => 'query',
          'description' => 'tags to filter by',
          'required' => false,
          'style' => 'form',
          'schema' => { 'type' => 'array', 'items' => { 'type' => 'string' } }
        }
      end

      specify do
        expect(subject.name).to eql 'tags'
        expect(subject.definition.keys).to match_array %w[
          description in required style schema
        ]
      end
    end
  end

  describe 'references' do
    subject { described_class.new(definition:, components:) }

    let(:definition) do
      { '$ref' => '#/components/parameters/rowParam' }
    end

    let(:components) do
      {
        'parameters' => {
          'rowParam' => {
            'description' => 'Board row (vertical coordinate)',
            'name' => 'row',
            'in' => 'path',
            'required' => true,
            'schema' => {
              '$ref' => '#/components/schemas/coordinate'
            }
          },
          'columnParam' => {
            'description' => 'Board column (horizontal coordinate)',
            'name' => 'column',
            'in' => 'path',
            'required' => true,
            'schema' => {
              '$ref' => '#/components/schemas/coordinate'
            }
          }
        },
        'schemas' => {
          'coordinate' => {
            'type' => 'integer',
            'minimum' => 1,
            'maximum' => 3,
            'example' => 1
          }
        }
      }
    end

    specify do
      expect(subject.name).to eql 'row'
      expect(subject.definition.keys).to match_array %w[
        description in required schema
      ]
    end
  end
end
