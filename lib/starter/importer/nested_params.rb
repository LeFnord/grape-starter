# frozen_string_literal: false

module Starter
  module Importer
    class NestedParams < Parameter
      def initialize(name:, definition:)
        @name = name
        @definition = definition
      end
    end
  end
end
