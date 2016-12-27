# frozen_string_literal: true
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('../../lib/**/*.rb', __FILE__)].each do |lib|
  require lib
end

Dir[File.expand_path('../../api/entities/*.rb', __FILE__)].each do |entity|
  require entity
end

Dir[File.expand_path('../../api/endpoints/*.rb', __FILE__)].each do |endpoint|
  require endpoint
end

require 'base'

require 'rack'
# provides the documentation of the API
class DocApp
  attr_reader :env
  def call(env)
    @env = env
    [200, { 'Content-Type' => 'text/html' }, [template]]
  end

  def template
    "<!DOCTYPE html>
    <html>
      <head>
        <title>ReDoc API documentation</title>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <style>body {margin: 0;padding: 0;}</style>
      </head>
      <body>
        <redoc spec-url='http://#{server}:#{port}/#{Api::Base.prefix}/#{Api::Base.version}/oapi.json'></redoc>
        <script src='https://rebilly.github.io/ReDoc/releases/latest/redoc.min.js'> </script>
      </body>
    </html>"
  end

  def server
    @env['SERVER_NAME']
  end

  def port
    @env['SERVER_PORT']
  end
end

# provides the routing between the API and the html documentation of it
class App
  def initialize
    @apps = {}
  end

  def call(env)
    if env['REQUEST_PATH'].start_with?("/#{Api::Base.prefix}")
      Api::Base.call(env)
    else
      DocApp.new.call(env)
    end
  end
end
