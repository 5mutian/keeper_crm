class Customer < ActiveRecord::Base

	validates_uniqueness_of :tel, message: '手机号已被使用'

	belongs_to :account
	belongs_to :user
	has_many :orders
	
end
