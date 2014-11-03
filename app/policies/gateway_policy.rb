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

end
