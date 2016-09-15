require 'api/version'

module Api
  APP_CLASS = name

  # TODO: requirer endpoint classes

  class Printer
    class << self
      def call(message)
        message.blank? ? "welcome at #{APP_CLASS}" : message
      end
    end
  end

  autoload :Rake, 'api/rake/grape_tasks'
end
