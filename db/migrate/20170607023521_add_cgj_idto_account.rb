class AddCgjIdtoAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :cgj_id, :integer
  end
end
