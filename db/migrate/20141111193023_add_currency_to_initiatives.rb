class AddCurrencyToInitiatives < ActiveRecord::Migration
  def change
    add_column :initiatives, :currency, :string, null: false, default: 'USD'
  end
end
