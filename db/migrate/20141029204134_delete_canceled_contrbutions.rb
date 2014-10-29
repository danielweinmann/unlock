class DeleteCanceledContrbutions < ActiveRecord::Migration
  def up
    execute "DELETE FROM contributions WHERE state = 5"
  end
  def down
    # No turning back
  end
end
