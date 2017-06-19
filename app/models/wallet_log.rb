class WalletLog < ActiveRecord::Base

  include Pingppable

	belongs_to :user

	STATE = {
    -1 => 'invalid',
    0  => 'prehead',
    1  => 'completed'
  }
  TRANSFER = {
    0  => 'deposit',        # 存进
    1  => 'spend',          # 支出
    2  => 'receipt',        # 收入
    3  => 'withdraw',       # 提现
    -1 => 'withdraw_failed' # 当pingXX反回结果失败的话生成一个记录，将提现失败的金额返给钱包
  }

  validates :trade_type, inclusion: {in: [nil, 'alipay', 'wx'], message: '不在所选范围之内'} 

  validates_numericality_of :amount, greater_than_or_equal_to: 0.01, message: "流水金额大于0.01"
  validates_numericality_of :total, greater_than_or_equal_to: 0, message: "帐户总额必须大于等于0"


  # 支付/充值
  def generate_pay(remote_ip="127.0.0.1")
    charge = self.pingpp_charge(payment_options(remote_ip))
    charge
  end

  # 提现
  def generate_withdraw
    transfer = self.pingpp_transfer(withdraw_options)
    transfer
  end

  def p_hash
    {
      order_no: "wallet#{id}",
      channel:  trade_type,
      amount:   amount * 100,
      currency: "cny"
    }
  end

  def payment_options(remote_ip="127.0.0.1")
    p_hash.merge(
      subject:  '支付/充值',
      body:     '',
      client_ip: remote_ip
    )
  end

  def withdraw_options
    p_hash.merge(
      type:     "b2c",
      recipient: user.open_id,
      description: "提现到微信"
    )
  end

end
