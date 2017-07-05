class AddBankCardInfosToWalletLog < ActiveRecord::Migration
  def change
  	add_column :wallet_logs, :account_number, :string
  	add_column :wallet_logs, :account_bank,   :string
  	add_column :wallet_logs, :account_branch, :string
  	add_column :wallet_logs, :account_name,   :string
  end
end
