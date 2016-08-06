require 'starter/version'

module Starter
  APP_CLASS = name

  class Printer
    class << self
      def call(_message)
        message = 'welcome …'
      end
    end
  end

  autoload :Rake, 'starter/rake/grape_tasks'
end
