class Product < ActiveRecord::Base

	def to_hash
		{
			id: id,
			name: name,
			code: code
		}
	end
	
end
