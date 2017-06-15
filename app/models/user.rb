class User < ActiveRecord::Base

	attr_accessor :remeber_token
 	has_secure_password

  mount_base64_uploader :avatar, AvatarUploader

  ROLES = {
      admin: %w(customers clues orders stores users strategies accounts),
      saler: %w(clues orders customers),
      cs: %w(orders customers stores),
      acct: %w(orders),
      saler_director: %w(orders)
    }

  validates_uniqueness_of :mobile, message: '手机号已被使用'
  validates :status, inclusion: {in: [-1, 0, 1], message: '不在所选范围之内'} 
  validates :role,   inclusion: {in: ['admin', 'cs', 'saler', 'acct', 'saler_director', 'introducer'], message: '不在所选范围之内'} 

 	belongs_to :account
 	has_one :token
  has_many :clues
  has_many :orders
  has_many :customers
  has_and_belongs_to_many :permissions
  has_many :wallet_logs
  has_many :applies

  has_many :children, foreign_key: "saler_director_id", class_name: 'User'

 	delegate :t_value, to: :token
  delegate :type, to: :account

 	after_create :gen_token, :set_permissions

 	def gen_token
 		Token.create(user_id: id, t_value: SecureRandom.base64(64))
 	end

  def set_permissions
    _actions = ROLES[self.role.to_sym].map {|val| "%#{val}%"}
    self.permissions = Permission.where("_controller_action ILIKE ANY ( array[?] )", _actions)
    self.save
  end

  def is_valid?
    status == 1 ? true : false
  end

  def children_list
    children.map(&:to_hash)
  end
  #用来加密remeber_token，然后保存到数据库中的remeber_digest中去
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  #生成随机的字符串
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  #每次登录成功或者注册后，都会调用remeber的方法，将remeber_token这个随机字符串加密后更新到数据库中的remeber_digest的值
  def remeber
    self.remeber_token = User.new_token
    self.update_attribute(:remeber_digest, User.digest(remeber_token))
  end
  #用来判断cookies[:remeber_token]中的值通过BCrypt加密后，是否与数据库中的一致
  def authenticated?(remeber_token)
    return false if remeber_digest.nil?
    BCrypt::Password.new(remeber_digest).is_password?(remeber_token)
  end
  #退出登录时调用，将数据库是的rember_digest值置为nil
  def forget
    self.update_attribute(:remeber_digest, nil)
  end

  def self.find_by_access_token(t_value)
  	Token.includes(:user).find_by_t_value(t_value).try(:user)
  end

  # format
  def to_hash
    {
      id:     id,
      name:   name,
      mobile: mobile,
      role:   role,
      children: children_list
    }
  end

  # role menu
  def right_menu
    {
      "admin"           => {customers: '客户', clues: '线索', orders: '订单', stores: '门店／渠道', users: '用户', strategies: '策略', accounts: '品牌'},
      "saler"           => {customers: '客户', clues: '线索', orders: '订单'},
      "saler_director"  => {customers: '客户', clues: '线索', orders: '订单'},
      "cs"              => {customers: '客户', orders: '订单', stores: '门店／渠道'},
      "acct"            => {orders: '订单'}
    }[role]
  end

  def self.get_or_gen_introducer(mobile, name, account_id)
    introducer = self.find_or_initialize_by(mobile: mobile)

    if introducer.new_record?
      introducer.name = name
      introducer.role = 'introducer'
      introducer.account_id = account_id
      introducer.password = 'crm123'
      introducer.save
    end
    introducer
  end

  def cgj_hash
    {
      id:               cgj_user_id,
      tel:              mobile,
      real_name:        name,
      password_digest:  password_digest,
      company_id:       account.cgj_id,
      region:           'CRM'
    }
  end

  # wallet
  def wallet
    {
      amount: wallet_total,
      income: income,
      expend: expend
    }
  end

  def wallet_total
    wallet_logs.where(state: 1).last.try(:total).to_f.round(2)
  end

  def income
    wallet_logs.where(state: 1, transfer: 2).map(&:amount).sum.to_f.round(2)
  end

  def expend
    wallet_logs.where(state: 1, transfer: 1).map(&:amount).sum.to_f.round(2)
  end
  # ###########################
  # 登录后给到所有的用户信息
  def infos
    attributes.merge(account_type: type, wallet: wallet, avatar_url: avatar_url + "?#{Time.now.to_i}")
  end

end
