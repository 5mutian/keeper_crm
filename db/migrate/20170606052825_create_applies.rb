class CreateApplies < ActiveRecord::Migration
  def change
    create_table :applies do |t|
    	t.integer :target_user_id, null: false
    	t.string :resource_name, null: false
    	t.integer :resource_id, null: false
    	t.string :_action
    	t.integer :state, default: 0
    	t.string :remark

    	t.references :user, null: false
      t.timestamps null: false
    end
  end
end
