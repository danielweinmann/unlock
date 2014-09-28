class ContributionPolicy < ApplicationPolicy

  def pay?
    is_owner_or_admin?
  end

  def activate?
    update?
  end
  
  def suspend?
    update?
  end
  
  def cancel?
    update?
  end
  
end
