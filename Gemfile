# frozen_string_literal: true
source 'http://rubygems.org'

ruby '2.3.1'

# TODO: add a tag
gem 'thin'

gem 'rack'
gem 'rack-cors'
gem 'mime-types'

gem 'grape'
gem 'grape-entity'
# TODO: change back after release
gem 'grape-swagger', git: 'git@github.com:ruby-grape/grape-swagger.git'
# gem 'grape-swagger', path: '../grape-swagger'
gem 'grape-swagger-entity'

gem 'json'

group :development do
  gem 'pry'
  gem 'rake'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rack'
  gem 'rubocop'
  gem 'awesome_print', require: false
end

group :test do
  gem 'rspec'
  gem 'rack-test'
end
