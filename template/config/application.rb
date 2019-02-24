# frozen_string_literal: true

require_relative 'environment'
require_relative 'boot'

require 'base'

# provides the documentation of the API
class DocApp
  def call(env)
    @env = env
    [200, { 'Content-Type' => 'text/html' }, [template]]
  end

  def template
    prefix = Api::Base.prefix ? "/#{Api::Base.prefix}" : ''
    "<!DOCTYPE html>
    <html>
      <head>
        <title>ReDoc API documentation</title>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <style>body {margin: 0;padding: 0;}</style>
      </head>
      <body>
        <redoc spec-url='http://#{server}:#{port}#{prefix}/#{Api::Base.version}/oapi.json'></redoc>
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

# provides the routing between the API and the ReDoc documentation of it
class App
  def initialize
    @apps = {}
  end

  def call(env)
    if Api::Base.recognize_path(env['REQUEST_PATH'])
      Api::Base.call(env)
    elsif env['REQUEST_PATH'] == '/doc'
      DocApp.new.call(env)
    else
      [403, { 'Content-Type': 'text/plain' }, ['403 Forbidden']]
    end
  end
end
