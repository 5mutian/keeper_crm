class Company < Account

  belongs_to :parent, class_name: 'Account'

  def sync_cgj
    res = Cgj.create_company(c.cgj_hash)
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
      user:         admin.cgj_hash
    }
  end

  def select_companies
    [self.select_hash]
  end
	
end