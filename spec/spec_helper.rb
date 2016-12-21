# frozen_string_literal: true

require 'grape'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'starter'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation

  config.mock_with :rspec
  config.expect_with :rspec

  # config.warnings = true
  config.raise_errors_for_deprecations!
end
