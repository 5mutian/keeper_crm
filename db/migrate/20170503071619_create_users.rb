class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mobile, null: false, unique: true
      t.string :password_digest
      t.string :remeber_digest
      t.string :name, null: false
      t.string :role, null: false
      t.integer :status, default: 1
      t.string :open_id
      t.string :cgj_token

      t.references :account, null: false

      t.timestamps null: false
    end
  end
end
