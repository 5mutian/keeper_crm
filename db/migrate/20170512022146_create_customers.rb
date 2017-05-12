class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
    	t.string :name, null: false
    	t.string :tel, null: false # 手机号不唯一，一个客户可能在多个销售那里下过单
    	t.string :province
    	t.string :city
    	t.string :area
    	t.string :street
    	t.string :address
    	t.string :longitude
    	t.string :latitude

    	t.references :user, null: false # 属于某个saler
    	t.references :account, null: false

      t.timestamps null: false
    end
  end
end
