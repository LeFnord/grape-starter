# frozen_string_literal: false

require 'rack/cors'
require_relative 'config/application'

use Rack::CommonLogger

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post put patch delete options]
  end
end

run App.new
