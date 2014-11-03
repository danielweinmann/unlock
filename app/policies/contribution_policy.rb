class ContributionPolicy < ApplicationPolicy

  def new?
    user && record.gateway && !record.gateway.draft? && record.initiative && record.initiative.permalink.present?
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
  
  def permitted_attributes
    if create?
      [:value, :initiative_id, :gateway_id, :user_id, :hide_name, :hide_value, user_attributes: [ :id, :full_name, :document, :phone_area_code, :phone_number, :birthdate, :address_street, :address_number, :address_complement, :address_district, :address_city, :address_state, :address_zipcode ]]
    else
      []
    end
  end

end
