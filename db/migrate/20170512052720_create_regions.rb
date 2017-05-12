class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
    	t.string :name, null: false, unique: true
    	t.string :code, null: false, unique: true
    	
    	t.references :account, null: false

      t.timestamps null: false
    end
  end
end
