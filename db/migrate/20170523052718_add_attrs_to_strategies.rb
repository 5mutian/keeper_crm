class AddAttrsToStrategies < ActiveRecord::Migration
  def change
  	add_column :stategies, :title, :string # 主题
  	add_column :stategies, :discount, :float
  	add_column :stategies, :rebate, :float
  end
end
