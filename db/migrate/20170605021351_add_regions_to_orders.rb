class AddRegionsToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :region_id, :string # 渠道
  	add_column :orders, :store_id, :string # 门店
  end
end
