# frozen_string_literal: true

require 'awesome_print'
require 'active_support'
require 'active_support/core_ext/string'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module Starter
  autoload :Rake, 'starter/rake/grape_tasks'
end
