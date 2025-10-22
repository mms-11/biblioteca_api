module Types
  class AuthorType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    field :id, ID, null: false
    field :type, String, null: false
    field :name, String, null: false
    field :city, String, null: true
    field :birthdate, GraphQL::Types::ISO8601Date, null: true
    field :materials_count, Integer, null: false

    def materials_count
      object.materials.count
    end
  end
end
