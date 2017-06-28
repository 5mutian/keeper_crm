class AddAssignToClues < ActiveRecord::Migration
  def change
  	add_column :clues, :assign_user_id, :integer
  end
end
