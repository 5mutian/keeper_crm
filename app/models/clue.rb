class Clue < ActiveRecord::Base

	belongs_to :account
	belongs_to :user
	belongs_to :customer

	belongs_to :assign_user, class_name: 'User'

	before_create :gen_customer_id

	def gen_customer_id
		self.customer_id = 0 unless customer_id
	end

end
