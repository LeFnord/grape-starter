# frozen_string_literal: true

require 'starter'

require 'grape'
require 'rspec_command'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include RSpecCommand

  config.color = true
  config.formatter = :documentation

  config.mock_with :rspec
  config.expect_with :rspec

  config.warnings = true
  config.raise_errors_for_deprecations!
end
