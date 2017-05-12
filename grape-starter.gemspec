# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'starter/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape-starter'
  spec.version       = Starter::VERSION
  spec.authors       = ['LeFnord']
  spec.email         = ['pscholz.le@gmail.com']

  spec.summary       = 'Create a Grape Rack skeleton'
  spec.description   = 'CLI to create a API skeleton based on Grape and Rack'
  spec.homepage      = 'https://github.com/LeFnord/grape-starter'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.6'

  spec.add_dependency 'gli', '~> 2.16'
  spec.add_dependency 'activesupport', '~> 5.0'
  spec.add_dependency 'rubocop', '~> 0.48'
  spec.add_dependency 'awesome_print', '~> 1.7'
end
