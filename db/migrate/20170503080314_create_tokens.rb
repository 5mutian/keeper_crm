class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :t_value

      t.references :user, null: false

      t.timestamps null: false
    end
  end
end
