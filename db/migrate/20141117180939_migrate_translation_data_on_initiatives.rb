class MigrateTranslationDataOnInitiatives < ActiveRecord::Migration
  def up
    execute("UPDATE initiatives SET name_translations = ('pt => \"' || REPLACE(name, '\"', '\\\"') || '\"')::hstore, first_text_translations = ('pt => \"' || REPLACE(first_text, '\"', '\\\"') || '\"')::hstore, second_text_translations = ('pt => \"' || REPLACE(second_text, '\"', '\\\"') || '\"')::hstore")
    remove_column :initiatives, :name
    remove_column :initiatives, :first_text
    remove_column :initiatives, :second_text
  end

  def down
    add_column :initiatives, :name, :text
    add_column :initiatives, :first_text, :text
    add_column :initiatives, :second_text, :text
    execute("UPDATE initiatives SET name = (name_translations -> 'pt')::text, first_text = (first_text_translations -> 'pt')::text, second_text = (second_text_translations -> 'pt')::text")
  end
end
