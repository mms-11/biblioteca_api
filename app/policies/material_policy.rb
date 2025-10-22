class MaterialPolicy < ApplicationPolicy #garante que apenas o criador exclue o marterial
  def index?  = true
  def show?   = record.published? || user&.id == record.creator_id
  def create? = user.present?

  def update?
    user.present? && user.id == record.creator_id
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve #qualquer usuario logado ve os arquvios de outros publicados
      if user
        scope.where("status = ? OR creator_id = ?", Material.statuses[:published], user.id)
      else
        scope.published
      end
    end
  end
end
