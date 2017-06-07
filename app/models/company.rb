class Company < Account

	def co_applies
		Apply.where(resource_name: 'Company', resource_id: id, _action: "cooperate").map(&:cooperate_hash)
	end

	def select_hash
  	{
  		id: id,
  		name: name,
  		logo: logo.try(:url)
  	}
  end
	
end