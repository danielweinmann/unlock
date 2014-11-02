class AddStateToInitiatives < ActiveRecord::Migration
  def change
    add_column :initiatives, :state, :string
    add_index :initiatives, :state
  end
end
