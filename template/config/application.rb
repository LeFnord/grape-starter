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
  def call(env)
    [200, { 'Content-Type' => 'text/html' }, [re_doc(env)]]
  end

  def re_doc(env)
    doc = template.sub('{{{server}}}', env['SERVER_NAME'])
    doc = doc.sub('{{{port}}}', env['SERVER_PORT'])

    doc
  end

  def template
    "<!DOCTYPE html>
    <html>
      <head>
        <title>ReDoc API documentation</title>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <style>
          body {
            margin: 0;
            padding: 0;
          }
        </style>
      </head>
      <body>
        <redoc spec-url='http://{{{server}}}:{{{port}}}/api/v1/oapi.json'></redoc>
        <script src='https://rebilly.github.io/ReDoc/releases/latest/redoc.min.js'> </script>
      </body>
    </html>"
  end
end

# provides the routing between the API and the html documentation of it
class App
  def initialize
    @apps = {}
  end

  def map(route, app)
    @apps[route] = app
  end

  def call(env)
    request = Rack::Request.new(env)
    if env['REQUEST_PATH'].start_with?('/api')
      @apps['/api'].call(env)
    elsif @apps[request.path]
      @apps[request.path].call(env)
    end
  end
end
