class CreateBankCards < ActiveRecord::Migration
  def change
    create_table :bank_cards do |t|
    	t.string :code, null: false
    	t.string :account, null: false
    	t.string :branch, null: false
    	t.string :name, null: false

    	t.references :user, null: false

      t.timestamps null: false
    end
  end
end
