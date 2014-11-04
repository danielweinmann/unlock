class RemoveDescriptionFromGateways < ActiveRecord::Migration
  def change
    remove_column :gateways, :description
  end
end
