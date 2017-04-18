# frozen_string_literal: false

require 'rack/cors'

use Rack::CommonLogger

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post put patch delete options]
  end
end

require File.expand_path('../config/application', __FILE__)

run App.new
