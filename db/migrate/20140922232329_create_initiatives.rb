class CreateInitiatives < ActiveRecord::Migration
  def change
    create_table :initiatives do |t|
      t.text :permalink
      t.text :name
      t.text :first_text
      t.text :second_text
      t.references :user
    end
    add_index :initiatives, :user_id
  end
end
