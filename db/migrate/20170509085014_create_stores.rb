class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
    	t.string :name, null: false, unique: true
    	t.string :code, null: false, unique: true
    	t.string :contact
    	t.string :phone
    	t.string :address
    	t.text  :product_ids, array: true, default: []
    	
    	t.references :account, null: false
    	t.references :channel, null: false

      t.timestamps null: false
    end
  end
end
