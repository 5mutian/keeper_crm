class Dealer < Account

  def unco_companies
  	Company.where.not(id: company_ids).map(&:select_hash)
  end
  
end
