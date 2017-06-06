class AddLogoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :accounts, :logo, :string
  end
end
