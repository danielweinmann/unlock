class AddMinimumValueToInitiatives < ActiveRecord::Migration
  def change
    add_column :initiatives, :minimum_value, :integer, default: 5
  end
end
