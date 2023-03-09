# frozen_string_literal: true

RSpec.shared_context 'specification' do
  let(:default_specification) do
    {
      openapi: '3.1.0',
      info: {
        title: 'some api',
        description: 'some api description',
        version: '1.0.0'
      },
      paths: {}
    }
  end
end
