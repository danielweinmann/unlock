module Initiatives::ContributionsHelper
  def can_manage_contribution? contribution
    policy(contribution.initiative).update? || policy(contribution).update?
  end
end