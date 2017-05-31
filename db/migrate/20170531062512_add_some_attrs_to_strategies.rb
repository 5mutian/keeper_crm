class AddSomeAttrsToStrategies < ActiveRecord::Migration
  def change
  	add_column :strategies, :province, :string # 省
  	add_column :strategies, :city, :string # 市
  	add_column :strategies, :area, :string # 区
  	add_column :strategies, :region_id, :integer # 渠道

  	add_column :orders, :province, :string # 省
  	add_column :orders, :city, :string # 市
  	add_column :orders, :area, :string # 区
  end
end
