class CreateValidCodes < ActiveRecord::Migration
  def change
    create_table :valid_codes do |t|
    	t.string :mobile, null: false
    	t.string :code, null: false
    	t.boolean :state, default: true

      t.timestamps null: false
    end
  end
end
