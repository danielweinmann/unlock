class ContributionPolicy < ApplicationPolicy

  def create?
    user && record.gateway
  end

  def pay?
    update?
  end

  def activate?
    update?
  end
  
  def suspend?
    update?
  end
  
end
