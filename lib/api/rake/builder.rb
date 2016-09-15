module Api
  module Rake
    require 'api/rake/names'
    class Builder
      class << self
        def build(resource)
          @resource = resource
          @names = Api::Rake::Names.build(@resource)
          build_name_methods
          self
        end

        private

        def build_name_methods
          @names.each do |name|
            self.class.send(:define_method, name.first, -> { name.last })
          end
        end
      end
    end
  end
end
