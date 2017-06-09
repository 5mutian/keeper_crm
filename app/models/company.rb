class Company < Account

  belongs_to :parent, class_name: 'Account'

  after_save :sync_cgj

  def sync_cgj
    res = Cgj.create_company(cgj_hash)
    _hash = JSON res.body

    if _hash["code"] == 200

      account_info = _hash[:customer][:account_info]
      self.parent.update_attributes(cgj_id: account_info[:id]) if account_info
      
      account_manager = params[:customer][:account_manager]
      self.parent.admin.update_attributes(cgj_user_id: account_manager[:id]) if account_manager

      self.update_attributes(cgj_id: params[:customer][:id])

      manager_info = params[:customer][:manager_info]
      self.admin.update_attributes(cgj_user_id: manager_info[:id]) if manager_info
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
	
end