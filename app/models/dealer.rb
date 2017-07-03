class Dealer < Account

  def menu
    {
      admin:          {customers: '客户', orders: '订单', clues: '线索', users: '用户', strategies: '策略', accounts: '品牌'},
      saler_director: {customers: '客户', orders: '订单', clues: '线索'},
      saler:          {customers: '客户', orders: '订单', clues: '线索'},
      cs:             {customers: '客户', orders: '订单', clues: '线索'},
      acct:           {orders: '订单'}
    }
  end

	def co_companies
		Account.where(id: company_ids)
	end

  def unco_companies
  	Company.where.not(id: company_ids).map(&:select_hash)
  end

  def wait_valid
  	Apply.includes(:user).where(state: 0, user_id: admin.id).map(&:wait_hash)
  end

  def select_companies
		co_companies.map(&:select_hash)
	end
  
end
