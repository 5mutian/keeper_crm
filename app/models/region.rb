class Region < ActiveRecord::Base

	belongs_to :account
	has_many :stores

	before_create :gen_code

	def gen_code
		self.code = 'CH' << SecureRandom.hex(2)
	end
end
