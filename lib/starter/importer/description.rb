# frozen_string_literal: false

module Starter
  module Importer
    class Description
      attr_accessor :content

      def initialize(content:)
        @content = content
      end

      def to_s # rubocop:disable Metrics/AbcSize
        return if content.blank?

        desc = content['summary'] || content['operationId']
        entry = "desc '#{desc}'\n"

        return entry unless block_keys.intersect?(content.keys)

        entry.sub!("\n", " do\n")
        entry << "  detail '#{content['description']}'\n" if content.key?('description')
        entry << "  tags #{content['tags']}\n" if content.key?('tags')
        entry << 'end'

        entry
      end

      def block_keys
        %w[
          description
          tags
        ]
      end
    end
  end
end
