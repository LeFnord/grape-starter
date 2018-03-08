# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('../config/initializers/*.rb', __dir__)].each do |initializer|
  require initializer
end

Dir[File.expand_path('../lib/**/*.rb', __dir__)].each do |lib|
  require lib
end

Dir[File.expand_path('../api/entities/*.rb', __dir__)].each do |entity|
  require entity
end

Dir[File.expand_path('../api/endpoints/*.rb', __dir__)].each do |endpoint|
  require endpoint
end
