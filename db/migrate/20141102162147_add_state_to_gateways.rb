class AddStateToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :state, :string
    add_index :gateways, :state
  end
end
