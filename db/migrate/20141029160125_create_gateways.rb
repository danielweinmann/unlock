class CreateGateways < ActiveRecord::Migration
  def change
    create_table :gateways do |t|
      t.references :initiative, index: true
      t.string :module_name, index: true
      t.integer :ordering
      t.text :title
      t.text :description
      t.hstore :settings
      t.boolean :active, default: false

      t.timestamps
    end
    add_index :gateways, [:initiative_id, :module_name], unique: true
    add_index :gateways, :settings, using: :gist
  end
end
