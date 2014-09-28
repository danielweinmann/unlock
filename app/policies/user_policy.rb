class UserPolicy < ApplicationPolicy
  
  def my_contributions?
    record
  end
  
end
