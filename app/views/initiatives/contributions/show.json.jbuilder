json.id @contribution.id
json.user do |json|
  if @contribution.hide_name?
    if policy(@initiative).update? || policy(@contribution).update?
      json.id @contribution.user.id
    end
    json.name "Apoiador anônimo"
  else
    json.id @contribution.user.id
    json.name @contribution.user.display_name
  end
  if policy(@initiative).update? || policy(@contribution).update?
    json.email @user.email
    json.full_name @user.full_name
    json.document @user.document
    json.phone_area_code @user.phone_area_code
    json.phone_number @user.phone_number
    json.birthdate @user.birthdate
    json.address_street @user.address_street
    json.address_number @user.address_number
    json.address_complement @user.address_complement
    json.address_district @user.address_district
    json.address_city @user.address_city
    json.address_state @user.address_state
    json.address_zipcode @user.address_zipcode
    json.created_at @user.created_at
    json.updated_at @user.updated_at
  end
end
json.value (@contribution.hide_value ? nil : @contribution.value)
json.created_at @contribution.created_at
json.updated_at @contribution.updated_at
json.hide_name @contribution.hide_name?
json.hide_value @contribution.hide_value?
json.gateway @contribution.gateway.module_name
json.gateway_state @contribution.gateway_state
json.state @contribution.state
