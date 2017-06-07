class Dealer < Account

  def unco_companies
  	Company.where.not(id: company_ids).map(&:select_hash)
  end

  def wait_valid
  	Apply.where(state: 0, user_id: admin.id).map(&:wait_hash)
  end
  
end
