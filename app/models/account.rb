class Account < ActiveRecord::Base
	has_many :users
	has_many :regions
	has_many :stores
	has_many :orders
	has_many :customers
	has_many :clues
	has_one  :admin, -> { where role: 'admin' }, class_name: 'User'
	has_many :saler_directors , -> { where role: 'saler_director' }, class_name: 'User'
	has_many :strategies

	before_create :gen_code

	def gen_code
		self.code = SecureRandom.hex(18).upcase
	end

	def invit_url
		"http://10.25.1.126:8081/#/invit?t=#{code}"
	end
end
