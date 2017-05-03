class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mobile
      t.string :password_digest
      t.string :remeber_digest
      t.string :name
      t.integer :account_id
      t.string :role

      t.timestamps null: false
    end
  end
end
