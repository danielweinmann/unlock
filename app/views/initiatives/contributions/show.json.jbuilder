json.id @contribution.id
json.user do |json|
  json.id @user.id
  if @contribution.hide_name?
    json.name "Apoiador anônimo"
  else
    json.name @user.display_name
  end
  if policy(@initiative).update?
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
  json.value (@contribution.hide_value ? nil : @contribution.value)
  json.created_at @contribution.created_at
  json.updated_at @contribution.updated_at
  json.sandbox @contribution.sandbox?
  json.hide_name @contribution.hide_name?
  json.hide_value @contribution.hide_value?
  json.state @contribution.state
end
