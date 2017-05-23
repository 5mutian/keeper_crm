class AddAttrsToStrategies < ActiveRecord::Migration
  def change
  	add_column :strategies, :title, :string # 主题
  	add_column :strategies, :discount, :float
  	add_column :strategies, :rebate, :float
  end
end
