class User < ActiveRecord::Base

	attr_accessor :remeber_token
 	has_secure_password

  validates :status, inclusion: {in: [-1, 0, 1], message: '不在所选范围之内'} 
  validates :role,   inclusion: {in: ['admin', 'cs', 'saler', 'acct'], message: '不在所选范围之内'} 

 	belongs_to :account
 	has_one :token
  has_many :clues
  has_many :orders
  has_and_belongs_to_many :permissions

 	delegate :t_value, to: :token

 	after_create :gen_token

 	def gen_token
 		Token.create(user_id: id, t_value: SecureRandom.base64(64))
 	end

  def is_valid?
    status == 1 ? true : false
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
      role:   role
    }
  end

end
