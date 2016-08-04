require 'starter/version'

module Starter
  class Printer
    class << self
      def call(_message)
        message = 'welcome …'
      end
    end
  end

  autoload :Rake, 'starter/rake/swagger'
end
