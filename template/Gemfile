# frozen_string_literal: true

source 'http://rubygems.org'

gem 'thin'

gem 'rack'
gem 'rack-cors'

# FIXME: lock to specific version before you are going into production
gem 'grape', git: 'git@github.com:ruby-grape/grape.git'
gem 'grape-entity', git: 'git@github.com:ruby-grape/grape-entity.git'
gem 'grape-swagger', git: 'git@github.com:ruby-grape/grape-swagger.git'
gem 'grape-swagger-entity', git: 'git@github.com:ruby-grape/grape-swagger-entity.git'

group :development, :test do
  gem 'grape-starter', git: 'git@github.com:LeFnord/grape-starter.git'
  gem 'pry'
  gem 'rack-test'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
end
