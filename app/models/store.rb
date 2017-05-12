class Store < ActiveRecord::Base

	belongs_to :account
	belongs_to :region

	before_create :gen_code

	def gen_code
		self.code = 'ST' << SecureRandom.hex(2)
	end

	def proeducts_hash
		Product.in(id: product_ids).map(&:to_hash)
	end

end
