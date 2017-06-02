class CreateStrategyResults < ActiveRecord::Migration
  def change
    create_table :strategy_results do |t|
    	t.integer :saler_id
    	t.float :saler_rate_amount
    	t.integer :customer_id
    	t.float :customer_discount_amount
    	t.integer :introducer_id
    	t.float :introducer_rebate_amount
    	t.string :remark

    	t.references :order, null: false
    	t.references :strategy, null: false
      t.timestamps null: false
    end
  end
end
