class CreateClues < ActiveRecord::Migration
  def change
    create_table :clues do |t|
    	t.string :name
    	t.string :mobile, null: false
    	t.string :address
      t.text   :remark

    	t.references :user, null: false
    	t.references :account, null: false
      t.references :customer
      t.timestamps null: false
    end
  end
end
