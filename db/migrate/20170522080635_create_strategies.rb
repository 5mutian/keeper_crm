class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
    	t.datetime :start_at
    	t.datetime :end_at
    	t.integer :product_id
    	t.float :rate
    	t.boolean :state, default: true

    	t.references :user
    	t.references :account, null: false

      t.timestamps null: false
    end
  end
end
