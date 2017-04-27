class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name, null: false, unique: true
      t.string :code, null: false, unique: true
      t.string :type, null: false
      t.string :reg_address
      t.string :address
      t.integer :company_ids, array: true

      t.timestamps null: false
    end
  end
end
