class AddTranslationColumnsToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :title_translations, :hstore
    add_column :gateways, :ordering_translations, :hstore
  end
end
