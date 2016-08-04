$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('../../api/endpoints/*.rb', __FILE__)].each do |endpoint|
  require endpoint
end

Dir[File.expand_path('../../api/entities/*.rb', __FILE__)].each do |entity|
  require entity
end

Dir[File.expand_path('../../lib/**/*.rb', __FILE__)].each do |f|
  require f
end

require 'base'
