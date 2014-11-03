class InitiativePolicy < ApplicationPolicy

  def publish?
    update?
  end

  def revert_to_draft?
    update?
  end

end
