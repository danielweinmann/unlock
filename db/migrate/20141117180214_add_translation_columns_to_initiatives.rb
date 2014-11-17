class AddTranslationColumnsToInitiatives < ActiveRecord::Migration
  def change
    add_column :initiatives, :name_translations, :hstore
    add_column :initiatives, :first_text_translations, :hstore
    add_column :initiatives, :second_text_translations, :hstore
  end
end
