class AddPoundToStrategies < ActiveRecord::Migration
  def change
  	add_column :strategies, :pound, :integer
  end
end
