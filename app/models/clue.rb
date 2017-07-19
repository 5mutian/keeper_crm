class Clue < ActiveRecord::Base

	validates_uniqueness_of :mobile, message: '手机号已被使用'

	belongs_to :account
	belongs_to :user
	belongs_to :customer

	belongs_to :assign_user, class_name: 'User'

	before_create :gen_customer_id

	def gen_customer_id
		self.customer_id = 0 unless customer_id
	end

	def to_hash
		attributes.merge(
			assign_user_name: assign_user.try(:name)
		)
	end

end
