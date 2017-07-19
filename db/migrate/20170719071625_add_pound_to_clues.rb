class AddPoundToClues < ActiveRecord::Migration
  def change
  	add_column :clues, :pound, :integer, default: 0
  end
end
