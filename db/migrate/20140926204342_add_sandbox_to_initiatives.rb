class AddSandboxToInitiatives < ActiveRecord::Migration
  def change
    add_column :initiatives, :sandbox, :boolean
  end
end
