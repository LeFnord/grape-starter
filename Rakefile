# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: %i[spec rubocop]
