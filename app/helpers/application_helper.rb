module ApplicationHelper

	def self.select_hash(_array=[])
		_array.collect{|_hash| {id: _hash["id"], name: _hash["name"]}}
	end

	def select_hash(_array=[])
		ApplicationHelper.select_hash(_array)
	end
end
