class Company < Account

	def select_hash
  	{
  		id: id,
  		name: name,
  		logo: logo.try(:url)
  	}
  end
	
end