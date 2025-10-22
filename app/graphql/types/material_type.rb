module Types
  class MaterialType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    field :id, ID, null: false
    field :type, String, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :status, String, null: false

    # específicos
    field :isbn, String, null: true
    field :page_count, Integer, null: true
    field :doi, String, null: true
    field :duration_minutes, Integer, null: true

    field :author, Types::AuthorType, null: false
    field :creator_id, ID, null: false
  end
end
