# TODO fix "nil?":{} attribute that is being mysteriously added
json.id contribution.id
json.user do |json|
  if contribution.hide_name?
    if can_manage_contribution?(contribution)
      json.id contribution.user.id
    end
    json.name Contribution.human_attribute_name(:hide_name?)
  else
    json.id contribution.user.id
    json.name contribution.user.display_name
  end
  if can_manage_contribution?(contribution)
    json.email contribution.user.email
    json.full_name contribution.user.full_name
    json.document contribution.user.document
    json.phone_area_code contribution.user.phone_area_code
    json.phone_number contribution.user.phone_number
    json.birthdate contribution.user.birthdate
    json.address_street contribution.user.address_street
    json.address_number contribution.user.address_number
    json.address_complement contribution.user.address_complement
    json.address_district contribution.user.address_district
    json.address_city contribution.user.address_city
    json.address_state contribution.user.address_state
    json.address_zipcode contribution.user.address_zipcode
    json.created_at contribution.user.created_at
    json.updated_at contribution.user.updated_at
  end
end
json.value ( (contribution.hide_value && !can_manage_contribution?(contribution)) ? nil : contribution.value)
json.created_at contribution.created_at
json.updated_at contribution.updated_at
json.hide_name contribution.hide_name?
json.hide_value contribution.hide_value?
json.gateway contribution.gateway.module_name
json.gateway_state contribution.gateway_state
json.state contribution.state
