class WalletLog < ActiveRecord::Base

	# trade_type: alipay, wx

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

  validates_numericality_of :amount, greater_than_or_equal_to: 0.01, message: "流水金额大于0.01"
  validates_numericality_of :total, greater_than_or_equal_to: 0, message: "帐户总额必须大于等于0"

end
