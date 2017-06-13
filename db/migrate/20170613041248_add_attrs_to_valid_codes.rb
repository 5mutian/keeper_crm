class AddAttrsToValidCodes < ActiveRecord::Migration
  def change
  	add_column :valid_codes, :_type, :integer
  end
end
