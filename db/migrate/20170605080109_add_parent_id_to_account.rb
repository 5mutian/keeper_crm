class AddParentIdToAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :parent_id, :integer
  end
end
