class Store < ActiveRecord::Base

	before_create :gen_code

	def gen_code
		self.code = 'ST' << SecureRandom.hex(2)
	end

end
