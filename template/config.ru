# frozen_string_literal: false
require 'rack/cors'

use Rack::CommonLogger

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end

require File.expand_path('../config/application', __FILE__)

app = App.new
app.map '/', DocApp.new
app.map '/api', Api::Base

run app
