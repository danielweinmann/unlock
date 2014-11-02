class SetInitiativesStates < ActiveRecord::Migration
  def up
    execute "UPDATE initiatives SET state = 'draft'"
    execute "UPDATE initiatives SET state = 'published' WHERE permalink IS NOT NULL AND permalink <> '' AND id IN (SELECT DISTINCT initiative_id FROM gateways WHERE state = 'production')"
  end

  def down
    execute "UPDATE initiatives SET state = null"
  end
end
