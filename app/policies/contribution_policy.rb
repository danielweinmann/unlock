class ContributionPolicy < ApplicationPolicy

  def pay?
    is_owner_or_admin?
  end

end
