class Account < ActiveRecord::Base
	# type: account, company, dealer 一个account可能有多个company
	# account
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

	# dealer
	def co_companies
		Account.where(id: company_ids)
	end


	# 获取有效的策略信息
	def get_valid_strategy(province, city, area)
		strategies.where(province: province, city: city, area: area).first
	end


	def stores_tree
		regions.map(&:select_hash)
	end
end
