class MigrateMoipAttributesToGateways < ActiveRecord::Migration
  def up
    execute("INSERT INTO gateways (initiative_id, module_name, ordering, settings, active) SELECT initiatives.id, 'UnlockMoip', 1, ('token => ' || moip_token || ', key => ' || moip_key || ', sandbox => ' || sandbox || '')::hstore, (moip_token IS NOT NULL AND moip_token <> '' AND moip_key IS NOT NULL AND moip_key <> '' AND NOT sandbox) FROM initiatives")
    remove_column :initiatives, :moip_token
    remove_column :initiatives, :moip_key
    remove_column :initiatives, :sandbox
  end

  def down
    add_column :initiatives, :moip_token, :text
    add_column :initiatives, :moip_key, :text
    add_column :initiatives, :sandbox, :boolean
    execute("UPDATE initiatives SET moip_token = (SELECT settings -> 'token' FROM gateways WHERE initiative_id = initiatives.id AND module_name = 'UnlockMoip'), moip_key = (SELECT settings -> 'key' FROM gateways WHERE initiative_id = initiatives.id AND module_name = 'UnlockMoip'), sandbox = (SELECT settings -> 'sandbox' FROM gateways WHERE initiative_id = initiatives.id AND module_name = 'UnlockMoip')::boolean")
    execute("DELETE FROM gateways WHERE module_name = 'UnlockMoip'")
  end
end
