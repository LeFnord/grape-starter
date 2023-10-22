# frozen_string_literal: false

# rubocop:disable Layout/LineLength
RSpec.describe Starter::Importer::Parameter do
  let(:components) do
    {
      'parameters' => {
        'rowParam' => {
          'description' => 'Board row (vertical coordinate)',
          'name' => 'row',
          'in' => 'path',
          'required' => true,
          'schema' => { '$ref' => '#/components/schemas/coordinate' }
        },
        'columnParam' => {
          'description' => 'Board column (horizontal coordinate)',
          'name' => 'column',
          'in' => 'path',
          'required' => true,
          'schema' => { '$ref' => '#/components/schemas/coordinate' }
        }
      },
      'schemas' => {
        'errorMessage' => { 'type' => 'string', 'maxLength' => 256, 'description' => 'A text message describing an error' },
        'coordinate' => { 'type' => 'integer', 'minimum' => 1, 'maximum' => 3, 'example' => 1 },
        'mark' => {
          'type' => 'string',
          'enum' => ['.', 'X', 'O'],
          'description' => 'Possible values for a board square. `.` means empty square.',
          'example' => '.'
        },
        'board' => {
          'type' => 'array',
          'maxItems' => 3,
          'minItems' => 3,
          'items' => { 'type' => 'array', 'maxItems' => 3, 'minItems' => 3, 'items' => { '$ref' => '#/components/schemas/mark' } }
        },
        'winner' => {
          'type' => 'string', 'enum' => ['.', 'X', 'O'], 'description' => 'Winner of the game. `.` means nobody has won yet.', 'example' => '.'
        },
        'status' => {
          'type' => 'object', 'properties' => { 'winner' => { '$ref' => '#/components/schemas/winner' }, 'board' => { '$ref' => '#/components/schemas/board' } }
        }
      }
    }
  end

  describe 'valid parameters -> sets kind' do
    describe 'name in definition -> :direct' do
      subject { described_class.new(definition:) }

      let(:definition) { { 'name' => 'limit' } }

      specify do
        expect { subject }.not_to raise_error
        expect(subject.kind).to eql :direct
      end
    end

    describe 'ref and components/parameters given -> :ref' do
      subject { described_class.new(definition:, components:) }

      let(:definition) { { '$ref' => '#/components/parameters/rowParam' } }
      let(:components) { { 'parameters' => { 'rowParam' => { 'name' => 'row' } } } }

      specify do
        expect { subject }.not_to raise_error
        expect(subject.kind).to eql :ref
      end
    end

    describe 'content given -> body' do
      subject { described_class.new(definition:, components:) }

      let(:definition) do
        {
          'content' => { 'application/json' => {
            'schema' => {
              '$ref' => '#/components/schemas/some_name'
            }
          } }
        }
      end
      let(:components) do
        {
          'schemas' => {
            'some_name' => {
              'required' => %w[crop name],
              'type' => 'object',
              'properties' => {}
            }
          }
        }
      end
      specify do
        expect { subject }.not_to raise_error
        expect(subject.kind).to eql :body
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

  subject { described_class.new(definition:, components:) }

  describe 'atomic parameter' do
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
      expect(subject.to_s).to eql(
        "optional :limit, type: Integer, documentation: { desc: 'maximum number of results to return', in: 'query' }"
      )
    end
  end

  describe 'reference atomic parameter' do
    let(:definition) do
      { '$ref' => '#/components/parameters/rowParam' }
    end

    specify do
      expect(subject.name).to eql 'row'
      expect(subject.definition.keys).to match_array %w[
        description in required schema
      ]
      expect(subject.definition['schema']['type']).to eql 'integer'
      expect(subject.to_s).to eql(
        "requires :row, type: Integer, documentation: { desc: 'Board row (vertical coordinate)', in: 'path' }"
      )
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
      expect(subject.to_s).to eql(
        "optional :tags, type: Array, documentation: { desc: 'tags to filter by', in: 'query' }"
      )
    end
  end

  describe 'request body: simple array' do
    let(:definition) do
      {
        'content' => {
          'multipart/form-data' => {
            'schema' => {
              'required' => ['ids'],
              'properties' => {
                'ids' => { 'type' => 'array', 'items' => { 'type' => 'integer', 'format' => 'int32' } }
              }
            }
          }
        },
        'required' => true,
        'in' => 'body'
      }
    end

    specify do
      expect(subject.name).to eql 'ids'
      expect(subject.definition.keys).to match_array %w[
        content in items required type
      ]
      expect(subject.to_s).to eql(
        "requires :ids, type: Array[Integer], documentation: { in: 'body' }"
      )
    end
  end

  describe 'request body: other' do
    let(:definition) do
      {
        'required' => true,
        'content' => {
          'application/form_data' => {
            'schema' => { '$ref' => '#/components/schemas/mark' }
          }
        }
      }
    end

    specify do
      expect(subject.name).to eql 'mark'
      expect(subject.definition.keys).to match_array %w[
        required content in type enum description example
      ]
      expect(subject.to_s).to include(
        "requires :mark, type: String, values: [\".\", \"X\", \"O\"], documentation: { desc: 'Possible values for a board square. `.` means empty square.', in: 'body' }"
      )
    end
  end

  describe 'request body: object' do
    let(:definition) do
      {
        'content' => {
          'application/json' => {
            'schema' => {
              '$ref' => '#/components/schemas/postApiV1CalibrationsCreating'
            }
          }
        },
        'required' => true,
        'in' => 'body'
      }
    end

    let(:components) do
      {
        'schemas' => {
          'postApiV1CalibrationsCreating' => {
            'required' => ['crop', 'name'], # rubocop:disable Style/WordArray
            'type' => 'object',
            'properties' => {
              'crop' => { 'type' => 'string', 'description' => 'The Crop of it.' },
              'name' => { 'type' => 'string', 'description' => 'The Name of it.' },
              'projects' => { 'type' => 'array', 'description' => 'The project(s) of it.', 'items' => { 'type' => 'string' } },
              'pools' => { 'type' => 'array', 'description' => 'The pool(s) of it.', 'items' => { 'type' => 'string' } },
              'material_level' => { 'type' => 'array', 'description' => 'The material level(s) of it.', 'items' => { 'type' => 'string' } },
              'material_groups' => { 'type' => 'array', 'description' => 'The material group(s) of it.', 'items' => { 'type' => 'string' } },
              'path' => { 'type' => 'string', 'description' => 'The path of it.' },
              'testers' => { 'type' => 'array', 'description' => 'The tester(s) of it.', 'items' => { 'type' => 'string' } },
              'locations' => { 'type' => 'array', 'description' => 'The location(s) of it.', 'items' => { 'type' => 'string' } },
              'years' => { 'type' => 'array', 'description' => 'The year(s) of it.', 'items' => { 'type' => 'integer', 'format' => 'int32' } },
              'tags' => { 'type' => 'array', 'description' => 'The tag(s) of it.', 'items' => { 'type' => 'string' } },
              'treatments' => { 'type' => 'array', 'description' => 'The treatment(s) of it.', 'items' => { 'type' => 'string' } },
              'id' => { 'type' => 'integer', 'description' => 'The ID of it (possible on back step, so editing is possible).', 'format' => 'int32' }
            },
            'description' => 'Creating Calibration'
          }
        }
      }
    end

    specify do
      expect(subject.name).to eql 'postApiV1CalibrationsCreating'
      expect(subject.definition.keys).to match_array %w[
        required content in type
      ]
      expect(subject.definition['type']).to eql 'object'

      expect(subject.to_s).to include(
        "requires :postApiV1CalibrationsCreating, type: JSON, documentation: { in: 'body' } do"
      )
      expect(subject.to_s).to include(
        "requires :crop, type: String, documentation: { desc: 'The Crop of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "requires :name, type: String, documentation: { desc: 'The Name of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :projects, type: Array[String], documentation: { desc: 'The project(s) of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :pools, type: Array[String], documentation: { desc: 'The pool(s) of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :material_level, type: Array[String], documentation: { desc: 'The material level(s) of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :material_groups, type: Array[String], documentation: { desc: 'The material group(s) of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :path, type: String, documentation: { desc: 'The path of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :testers, type: Array[String], documentation: { desc: 'The tester(s) of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :locations, type: Array[String], documentation: { desc: 'The location(s) of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :years, type: Array[Integer], documentation: { desc: 'The year(s) of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :tags, type: Array[String], documentation: { desc: 'The tag(s) of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :treatments, type: Array[String], documentation: { desc: 'The treatment(s) of it.', in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :id, type: Integer, documentation: { desc: 'The ID of it (possible on back step, so editing is possible).', in: 'body', format: 'int32' }"
      )
    end
  end

  describe 'request body: nested object' do
    let(:definition) do
      {
        'content' => {
          'application/json' => {
            'schema' => {
              '$ref' => '#/components/schemas/ordered'
            }
          }
        },
        'required' => true
      }
    end

    let(:components) do
      {
        'schemas' => {
          'ordered' => {
            'type' => 'object',
            'properties' => {
              'order' => {
                'type' => 'object',
                'properties' => {
                  'facet' => {
                    'type' => 'string',
                    'default' => 'score',
                    'enum' => %w[
                      created_at
                      updated_at
                      random
                    ]
                  },
                  'dir' => {
                    'type' => 'string',
                    'default' => 'asc',
                    'enum' => %w[
                      asc
                      desc
                    ]
                  }
                },
                'description' => 'Specify result order'
              },
              'per_page' => {
                'type' => 'integer',
                'format' => 'int32',
                'default' => 24
              },
              'page' => {
                'type' => 'integer',
                'format' => 'int32',
                'default' => 1
              },
              'choose' => {
                'type' => 'array',
                'items' => {
                  'type' => 'string',
                  'enum' => %w[a b]
                }
              }
            },
            'description' => 'something nested body request'
          }
        }
      }
    end

    specify do
      expect(subject.name).to eql 'ordered'
      expect(subject.definition.keys).to match_array %w[
        required content in type
      ]
      expect(subject.definition['type']).to eql 'object'

      expect(subject.to_s).to include(
        "requires :ordered, type: JSON, documentation: { in: 'body' } do"
      )
      expect(subject.to_s).to include(
        "optional :order, type: JSON, documentation: { desc: 'Specify result order', in: 'body' } do"
      )
      expect(subject.to_s).to include(
        "optional :facet, type: String, default: 'score', values: [\"created_at\", \"updated_at\", \"random\"], documentation: { in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :dir, type: String, default: 'asc', values: [\"asc\", \"desc\"], documentation: { in: 'body' }"
      )
      expect(subject.to_s).to include(
        "optional :per_page, type: Integer, default: '24', documentation: { in: 'body', format: 'int32' }"
      )
      expect(subject.to_s).to include(
        "optional :page, type: Integer, default: '1', documentation: { in: 'body', format: 'int32' }"
      )
      expect(subject.to_s).to include(
        "optional :choose, type: Array[String], documentation: { in: 'body' }"
      )
    end
  end
end
# rubocop:enable Layout/LineLength
