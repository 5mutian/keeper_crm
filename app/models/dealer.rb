class Dealer < Account

	def co_companies
		Account.where(id: company_ids)
	end

  def unco_companies
  	Company.where.not(id: company_ids).map(&:select_hash)
  end

  def wait_valid
  	Apply.where(state: 0, user_id: admin.id).map(&:wait_hash)
  end

  def select_companies
		co_companies.map(&:select_hash)
	end
  
end
