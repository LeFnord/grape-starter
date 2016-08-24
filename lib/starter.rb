require 'starter/version'

module Starter
  APP_CLASS = name

  class Printer
    class << self
      def call(message)
        message.blank? ? "welcome at #{APP_CLASS}" : message
      end
    end
  end

  autoload :Rake, 'starter/rake/grape_tasks'
end
