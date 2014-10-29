class MigrateContributionSandboxToGateway < ActiveRecord::Migration
  def up
    execute("UPDATE contributions SET gateway_data = ('sandbox => ' || sandbox)::hstore")
    remove_column :contributions, :sandbox
  end

  def down
    add_column :contributions, :sandbox, :boolean
    execute("UPDATE contributions SET sandbox = (gateway_data -> 'sandbox')::boolean, gateway_data = NULL")
  end
end
