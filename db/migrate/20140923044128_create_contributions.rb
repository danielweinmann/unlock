class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.references :user
      t.references :initiative
      t.float :value
      t.timestamps
    end
    add_index :contributions, :user_id
    add_index :contributions, :initiative_id
  end
end
