class AddImageColumnsToInitiatives < ActiveRecord::Migration
  def change
    add_attachment :initiatives, :image
    add_column :initiatives, :image_meta, :text
  end
end
