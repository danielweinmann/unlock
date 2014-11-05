class StoreGatewayDataOnContributions < ActiveRecord::Migration
  def up
    execute "UPDATE contributions SET gateway_data = ('customer_code => ' || (substring((SELECT permalink FROM initiatives WHERE initiatives.id = contributions.initiative_id) from 1 for 30) || user_id || (CASE WHEN gateway_state = 'sandbox' THEN 'sandbox' ELSE '' END)) || ', subscription_code => ' || (substring((SELECT permalink FROM initiatives WHERE initiatives.id = contributions.initiative_id) from 1 for 30) || id || (CASE WHEN gateway_state = 'sandbox' THEN 'sandbox' ELSE '' END)))::hstore"
  end
  def down
    execute "UPDATE contributions SET gateway_data = NULL"
  end
end
