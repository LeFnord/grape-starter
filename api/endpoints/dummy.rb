# frozen_string_literal: true
module Api
  module Entities
    class Class1
      class Entity < Grape::Entity
        expose :one_thing
      end
    end

    class Class2
      class Entities < Class1::Entity
        expose :one_thing
      end
    end

    class Class3
      class Entity < Grape::Entity
        expose :another_thing

        def self.entity_name
          'FooKlass'
        end
      end
    end

    class Class4
      class FourthEntity < Grape::Entity
        expose :another_thing

        def self.entity_name
          'BarKlass'
        end
      end
    end

    class Class5
      class FithEntity < Class4::FourthEntity
        expose :modes,
               documentation: {
                 is_array: true,
                 desc: 'Transport modes',
                 default: %w(driving train)
               }
      end
    end
  end

  module Endpoints
    class Dummy < Grape::API
      desc 'Class1::Entity', success: Api::Entities::Class1::Entity
      get :one do
        { message: 'hello world …!' }
      end

      desc 'Class2::Entities', success: Api::Entities::Class2::Entities
      get :two do
        { message: 'hello world …!' }
      end

      desc 'Class3::Entity', success: Api::Entities::Class3::Entity
      get :three do
        { message: 'hello world …!' }
      end

      desc 'Class4::FourthEntity', success: Api::Entities::Class4::FourthEntity
      get :four do
        { message: 'hello world …!' }
      end

      desc 'Class5::FithEntity', success: Api::Entities::Class5::FithEntity
      get :fith do
        { message: 'hello world …!' }
      end
    end
  end
end
