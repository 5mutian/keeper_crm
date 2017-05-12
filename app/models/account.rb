class Account < ActiveRecord::Base
	has_many :users
	has_many :regions
	has_many :stores
	has_many :orders
end
