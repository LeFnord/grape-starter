# frozen_string_literal: true
require 'spec_helper'

describe Api do
  it 'has a version number' do
    expect(Api::VERSION).not_to be nil
  end
end
