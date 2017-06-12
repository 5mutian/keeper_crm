class Company < Account

  belongs_to :parent, class_name: 'Account'

  # after_save :sync_cgj

  def sync_cgj
    res = Cgj.create_company(cgj_hash)
    _hash = JSON res.body

    if _hash["code"] == 200
      self.update_attributes(cgj_id: _hash["result"]["id"])

      manager = _hash["result"]["manager"]
      self.admin.update_attributes(cgj_user_id: manager["id"]) if manager
    end
  end

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

  def cgj_hash
    {
      id:           cgj_id,
      name:         name,
      address:      address,
      account_id:   parent.cgj_id,
      logo:         logo.url,
      user:         admin.cgj_hash
    }
  end
	
end