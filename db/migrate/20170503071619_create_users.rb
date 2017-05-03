class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mobile
      t.string :password_digest
      t.string :remeber_digest
      t.string :name
      t.string :role

      t.references :account_id, null: false

      t.timestamps null: false
    end
  end
end
