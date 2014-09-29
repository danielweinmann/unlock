class UserPolicy < ApplicationPolicy
  
  def my_contributions?
    record
  end
  
  def my_initiatives?
    record
  end
  
end
