class AddGatewayStateToContributions < ActiveRecord::Migration
  def up
    add_column :contributions, :gateway_state, :string
    execute "UPDATE contributions SET gateway_state = 'sandbox'"
    execute "UPDATE contributions SET gateway_state = 'production' WHERE gateway_data -> 'sandbox' = 'false'"
  end

  def down
    remove_column :contributions, :gateway_state
  end
end
