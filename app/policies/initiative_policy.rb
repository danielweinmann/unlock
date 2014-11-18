class InitiativePolicy < ApplicationPolicy

  def publish?
    update?
  end

  def revert_to_draft?
    update?
  end

  def update_states_from_gateways?
    update?
  end

  def permitted_attributes
    if create?
      [:name, :first_text, :second_text, :image, :permalink, :currency]
    else
      []
    end
  end

end
