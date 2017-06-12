class Account < ActiveRecord::Base

	mount_base64_uploader :logo, LogoUploader

	validates_uniqueness_of :name, message: '企业名称已被占用'
	# type: account, company, dealer 一个account可能有多个company
	# account
	# account， dealer必须有管理员，但company不一定有管理员。account_admin可以管理所有旗下的companies
	has_many :children, foreign_key: "parent_id", class_name: 'Company'

	has_many :users
	has_many :regions
	has_many :stores
	has_many :orders
	has_many :customers
	has_many :clues
	has_one  :admin, -> { where role: 'admin' }, class_name: 'User'
	has_many :saler_directors , -> { where role: 'saler_director' }, class_name: 'User'
	has_many :strategies

	before_create :gen_code

	def gen_code
		self.code = SecureRandom.hex(18).upcase
	end

	def invit_url
		"http://10.25.1.126:8081/#/invit?t=#{code}"
	end

	def select_companies
		children.map(&:select_hash)
	end

	# 获取有效的策略信息
	def get_valid_strategy(province, city, area)
		strategies.where(province: province, city: city, area: area).first
	end

	def stores_tree
		regions.map(&:select_hash)
	end

	def select_hash
  	{
  		id: id,
  		name: name,
  		logo: logo.try(:url),
  		cgj_id: cgj_id
  	}
  end

	def list_hash
		{
			id: 					id,
			name: 				name,
			admin_name: 	admin.try(:name),
			admin_mobile: admin.try(:mobile),
			state:        '通过'
		}
	end

	def account_hash
		children.map(&:list_hash)
	end

	def dealer_hash
		wait_valid + co_companies.map(&:list_hash)
	end

	def company_hash
		[list_hash]
	end

	def cgj_hash
    {
      id:           cgj_id,
      name:         name,
      address:      address,
      logo:         logo.url,
      cgj_id: 			cgj_id
    }
  end

end
