class CreateClues < ActiveRecord::Migration
  def change
    create_table :clues do |t|
    	t.string :name
    	t.string :mobile
    	t.string :address

    	t.references :user, null: false
    	t.references :account, null: false
      t.timestamps null: false
    end
  end
end
