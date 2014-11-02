class ChangeContributionStateToString < ActiveRecord::Migration
  def up
    change_column :contributions, :state, :string
    execute "UPDATE contributions SET state = 'pending' WHERE state = '0'"
    execute "UPDATE contributions SET state = 'active' WHERE state = '1'"
    execute "UPDATE contributions SET state = 'suspended' WHERE state = '2'"
  end

  def down
    add_column :contributions, :state_temp, :integer
    execute "UPDATE contributions SET state_temp = 0 WHERE state = 'pending'"
    execute "UPDATE contributions SET state_temp = 1 WHERE state = 'active'"
    execute "UPDATE contributions SET state_temp = 2 WHERE state = 'suspended'"
    remove_column :contributions, :state
    rename_column :contributions, :state_temp, :state
  end
end
