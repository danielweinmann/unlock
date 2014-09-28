class AddStateToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :state, :integer
    add_index :contributions, :state
  end
end
