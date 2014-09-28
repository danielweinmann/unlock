class AddSandboxToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :sandbox, :boolean
  end
end
