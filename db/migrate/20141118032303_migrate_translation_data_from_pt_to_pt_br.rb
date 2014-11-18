class MigrateTranslationDataFromPtToPtBr < ActiveRecord::Migration
  def up
    execute "UPDATE gateways SET title_translations = title_translations || ('pt-BR'::text => (title_translations -> 'pt')::text)"
    execute "UPDATE gateways SET ordering_translations = ordering_translations || ('pt-BR'::text => (ordering_translations -> 'pt')::text)"
    execute "UPDATE initiatives SET name_translations = name_translations || ('pt-BR'::text => (name_translations -> 'pt')::text)"
    execute "UPDATE initiatives SET first_text_translations = first_text_translations || ('pt-BR'::text => (first_text_translations -> 'pt')::text)"
    execute "UPDATE initiatives SET second_text_translations = second_text_translations || ('pt-BR'::text => (second_text_translations -> 'pt')::text)"
  end
  def down
    execute "UPDATE gateways SET title_translations = delete(title_translations, 'pt-BR')"
    execute "UPDATE gateways SET ordering_translations = delete(ordering_translations, 'pt-BR')"
    execute "UPDATE initiatives SET name_translations = delete(name_translations, 'pt-BR')"
    execute "UPDATE initiatives SET first_text_translations = delete(first_text_translations, 'pt-BR')"
    execute "UPDATE initiatives SET second_text_translations = delete(second_text_translations, 'pt-BR')"
  end
end
