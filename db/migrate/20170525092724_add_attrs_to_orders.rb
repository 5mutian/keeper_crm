class AddAttrsToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :introducer_name, :string
  	add_column :orders, :introducer_tel, :string
  	add_column :orders, :introducer_id, :integer
  end
end
