class AddSalerDirectorIdToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :saler_director_id, :integer
  end
end
