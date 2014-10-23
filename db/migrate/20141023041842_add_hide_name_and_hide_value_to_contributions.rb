class AddHideNameAndHideValueToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :hide_name, :boolean
    add_column :contributions, :hide_value, :boolean
  end
end
