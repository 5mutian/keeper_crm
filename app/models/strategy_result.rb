class StrategyResult < ActiveRecord::Base

	validates_uniqueness_of :order_id, message: '每条订单最终只能执行一条策略的结果'

	after_create :gen_wlogs

	def gen_wlogs
		# 销售提成
		WalletLog.create(transfer: 2, state: 1, amount: saler_rate_amount, total: saler.wallet_total + saler_rate_amount, user_id: saler.id)
		# 介绍人返利
		# 客户扣折
	end

	def saler
		User.find saler_id
	end

	def customer

	end

	def introducer
		User.find introducer_id
	end

end
