class AddIndexesToTranslationsColumns < ActiveRecord::Migration
  def change
    add_index :gateways, :title_translations, using: :gist
    add_index :gateways, :ordering_translations, using: :gist
    add_index :initiatives, :name_translations, using: :gist
    add_index :initiatives, :first_text_translations, using: :gist
    add_index :initiatives, :second_text_translations, using: :gist
  end
end
