# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require File.expand_path('../config/application', __dir__)

grape_starter_gem = Gem::Specification.find_by_name('grape-starter').gem_dir
Dir["#{grape_starter_gem}/lib/starter/rspec/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  include Rack::Test::Methods
  config.color = true
  config.formatter = :documentation

  config.mock_with :rspec
  config.expect_with :rspec

  config.raise_errors_for_deprecations!
end

def app
  Api::Base
end
