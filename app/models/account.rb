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
		"http://www.salesgj.com/#/invit?t=#{code}"
	end

	def menu
		{
      admin: {users: '用户', accounts: '品牌'},
      saler_director: {},
      saler:          {},
      cs:             {},
      acct:           {}
    }
	end

	def select_companies
		children.map(&:select_hash)
	end

	# 获取有效的策略信息
	def get_valid_strategy(province, city, area)
		valid_s = strategies.valid.where(province: province, city: city, area: area).order(pound: :desc, updated_at: :desc).first
		valid_s ? valid_s : common_strategy
	end

	def common_strategy
		strategies.valid.order(pound: :desc, updated_at: :desc).first
	end

	def stores_tree
		regions.map(&:select_hash)
	end

	def select_hash
  	{
  		id: id,
  		name: name,
  		logo: logo_url,
  		cgj_id: cgj_id
  	}
  end

	def list_hash
		{
			id: 					id,
			name: 				name,
			admin_name: 	admin.try(:name),
			admin_mobile: admin.try(:mobile),
			logo_url:     logo_url,
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
      logo:         logo.url
    }
  end

end
