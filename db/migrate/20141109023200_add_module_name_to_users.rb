class AddModuleNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :module_name, :string
  end
end
