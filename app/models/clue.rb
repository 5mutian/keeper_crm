class Clue < ActiveRecord::Base

	belongs_to :account
	belongs_to :user
	belongs_to :customer

	before_create :gen_customer_id

	def gen_customer_id
		self.customer_id = 0 unless customer_id
	end

end
