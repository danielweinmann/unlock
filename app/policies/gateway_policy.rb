class GatewayPolicy < ApplicationPolicy

  def use_sandbox?
    update?
  end
  
  def use_production?
    update?
  end

  def revert_to_draft?
    update?
  end

  def permitted_attributes
    if create?
      [:module_name, :title, :ordering, settings: [record.available_settings.map(&:key)]]
    else
      []
    end
  end

  protected

  def is_owned_by?(user)
    user.present? && record.initiative.present? && record.initiative.user == user
  end

end
