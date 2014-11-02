class SetGatewaysStates < ActiveRecord::Migration
  def up
    execute "UPDATE gateways SET state = 'draft'"
    execute "UPDATE gateways SET state = 'sandbox' WHERE active AND settings -> 'sandbox' = 'true'"
    execute "UPDATE gateways SET state = 'production' WHERE active AND settings -> 'sandbox' = 'false'"
  end

  def down
    execute "UPDATE gateways SET state = null"
  end
end
