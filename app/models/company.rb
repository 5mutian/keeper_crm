class Company < Account

  belongs_to :parent, class_name: 'Account'

  def menu
    {
      admin:          {customers: '客户', orders: '订单', clues: '线索', stores: '门店', users: '用户', strategies: '策略', accounts: '品牌审核'},
      saler_director: {customers: '客户', orders: '订单', clues: '线索'},
      saler:          {customers: '客户', orders: '订单', clues: '线索'},
      cs:             {customers: '客户', orders: '订单', stores: '门店'},
      acct:           {orders: '订单'}
    }
  end

  def sync_cgj
    res = Cgj.create_company(cgj_hash)
    _hash = JSON res.body

    if _hash["code"] == 200
      manager = _hash["result"]["manager"]
      if manager
        self.update_attributes(cgj_id: _hash["result"]["id"])
        self.admin.update_attributes(cgj_user_id: manager["id"])
      else
        self.update_attributes(cgj_id: _hash["result"]["company_id"])
        self.admin.update_attributes(cgj_user_id: _hash["result"]["id"])
      end
    end
  end

	def co_applies
		Apply.where(resource_name: 'Company', resource_id: id, _action: "cooperate", state: 0).map(&:cooperate_hash)
	end

  def cgj_hash
    {
      id:           cgj_id,
      name:         name,
      address:      address,
      account_id:   parent.cgj_id,
      logo:         logo_url,
      user:         admin.cgj_hash,
      account:      parent.cgj_hash,
      _account_user: parent.admin.cgj_hash
    }
  end

  def select_hash
    {
      id: id,
      name: name,
      logo: logo_url,
      cgj_id: cgj_id,
      stores_tree: stores_tree
    }
  end
	
end