# frozen_string_literal: true

require 'spec_helper'

describe Models do
  it 'has a version number' do
    expect(Models::VERSION).not_to be nil
  end
end
