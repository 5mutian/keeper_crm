class CreateWalletLogs < ActiveRecord::Migration
  def change
    create_table :wallet_logs do |t|
    	t.integer :transfer, null: false
    	t.integer :state, null: false
    	t.string :trade_type
    	t.string :charge_id

    	t.float :amount
    	t.float :total

    	t.references :strategy_result
    	t.references :user, null: false
      t.timestamps null: false
    end
  end
end
