# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

Bundler.require :default, ENV['RACK_ENV']

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir[File.expand_path('../config/initializers/*.rb', __dir__)].sort.each do |initializer|
  require initializer
end

Dir[File.expand_path('../lib/**/*.rb', __dir__)].sort.each do |lib|
  require lib
end

Dir[File.expand_path('../api/entities/*.rb', __dir__)].sort.each do |entity|
  require entity
end

Dir[File.expand_path('../api/endpoints/*.rb', __dir__)].sort.each do |endpoint|
  require endpoint
end
