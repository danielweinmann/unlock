class AddMoipTokenAndMoipKeyToInitiatives < ActiveRecord::Migration
  def change
    add_column :initiatives, :moip_token, :text
    add_column :initiatives, :moip_key, :text
  end
end
