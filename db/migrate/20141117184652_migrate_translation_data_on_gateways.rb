class MigrateTranslationDataOnGateways < ActiveRecord::Migration
  def up
    execute("UPDATE gateways SET title_translations = ('pt => \"' || title || '\"')::hstore, ordering_translations = ('pt => \"' || ordering || '\"')::hstore")
    remove_column :gateways, :title
    remove_column :gateways, :ordering
  end

  def down
    add_column :gateways, :title, :text
    add_column :gateways, :ordering, :integer
    execute("UPDATE gateways SET title = (title_translations -> 'pt')::text, ordering = (ordering_translations -> 'pt')::integer")
  end
end
