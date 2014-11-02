class SetContributionsGateways < ActiveRecord::Migration
  def up
    execute "UPDATE contributions SET gateway_id = (SELECT id FROM gateways WHERE gateways.initiative_id = contributions.initiative_id AND module_name = 'UnlockMoip')"
  end

  def down
    execute "UPDATE contributions SET gateway_id = null"
  end
end
