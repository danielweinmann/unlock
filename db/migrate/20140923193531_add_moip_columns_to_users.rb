class AddMoipColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :text
    add_column :users, :document, :text
    add_column :users, :phone_area_code, :text
    add_column :users, :phone_number, :text
    add_column :users, :birthdate, :date
    add_column :users, :address_street, :text
    add_column :users, :address_number, :text
    add_column :users, :address_complement, :text
    add_column :users, :address_district, :text
    add_column :users, :address_city, :text
    add_column :users, :address_state, :text
    add_column :users, :address_zipcode, :text
  end
end
