class MigrateInitiativesCurrencies < ActiveRecord::Migration
  def up
    execute "UPDATE initiatives SET currency = 'BRL'"
  end

  def down
    execute "UPDATE initiatives SET currency = 'USD'"
  end
end
