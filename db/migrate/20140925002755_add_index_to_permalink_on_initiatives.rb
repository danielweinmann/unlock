class AddIndexToPermalinkOnInitiatives < ActiveRecord::Migration
  def change
    add_index :initiatives, :permalink
  end
end
