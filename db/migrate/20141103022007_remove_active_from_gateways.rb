class RemoveActiveFromGateways < ActiveRecord::Migration
  def change
    remove_column :gateways, :active
  end
end
