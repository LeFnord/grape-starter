# frozen_string_literal: false

module Starter
  module Importer
    class Description
      attr_accessor :content

      def initialize(content:)
        @content = content
      end

      def to_s
        return if content.blank?

        desc = content['summary'] || name

        entry = "desc '#{desc}' do\n"
        entry << "  detail '#{content['description']}'\n" if content.key?('description')
        entry << "  tags #{content['tags']}\n" if content.key?('tags')
        entry << 'end'

        entry
      end
    end
  end
end
