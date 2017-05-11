class Channel < ActiveRecord::Base
	before_create :gen_code

	def gen_code
		self.code = 'CH' << SecureRandom.hex(2)
	end
end
