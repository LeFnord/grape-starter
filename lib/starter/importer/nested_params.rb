# frozen_string_literal: false

module Starter
  module Importer
    class NestedParams < Parameter
      def initialize(name:, definition:)
        @kind = :body
        @nested = []
        @name = name
        @definition = definition
      end
    end
  end
end
