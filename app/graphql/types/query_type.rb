module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :materials, [Types::MaterialType], null: false do
      argument :q, String, required: false
      argument :status, String, required: false
      argument :type, String, required: false
      argument :page, Integer, required: false, default_value: 1
      argument :per, Integer, required: false, default_value: 20
    end

    def materials(q: nil, status: nil, type: nil, page: 1, per: 20)
      scope = Pundit.policy_scope(context[:current_user], Material).includes(:author)
      scope = scope.search(q) if q.present?
      scope = scope.where(status:) if status.present?
      scope = scope.where(type:) if type.present?
      scope.order(created_at: :desc).page(page).per(per)
    end

    field :authors, [Types::AuthorType], null: false do
      argument :q, String, required: false
      argument :type, String, required: false
      argument :page, Integer, required: false, default_value: 1
      argument :per, Integer, required: false, default_value: 20
    end

    def authors(q: nil, type: nil, page: 1, per: 20)
      scope = Author.all
      scope = scope.where(type:) if type.present?
      scope = scope.where("name ILIKE ?", "%#{q}%") if q.present?
      scope.order(name: :asc).page(page).per(per)
    end
  end
end
