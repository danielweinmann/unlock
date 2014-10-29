class AddGatewayColumnsToContributions < ActiveRecord::Migration
  def change
    add_reference :contributions, :gateway, index: true
    add_column :contributions, :gateway_data, :hstore
  end
end
