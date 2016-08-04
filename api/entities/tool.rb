module Starter
  module Entities
    class Tool < Grape::Entity
      root 'tools', 'tool'
      expose :key
      expose :length,
              documentation: { type: String, desc: 'length of the tool' }
      expose :weight,
              documentation: { type: String, desc: 'weight of the tool' }
      expose :foo,
              documentation: { type: String, desc: 'foo' },
              if: ->(_tool, options) { options[:foo] } do |_tool, options|
                options[:foo]
              end
    end
  end
end
