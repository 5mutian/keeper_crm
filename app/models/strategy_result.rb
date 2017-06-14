class StrategyResult < ActiveRecord::Base

	validates_uniqueness_of :order_id, message: '每条订单最终只能执行一条策略的结果'

	after_create :gen_wlogs

	def gen_wlogs
		# 销售提成
		WalletLog.create(transfer: 2, state: 1, amount: saler_rate_amount, total: saler.wallet_total + saler_rate_amount, user_id: saler.id)
		# 介绍人返利
		WalletLog.create(transfer: 2, state: 1, amount: introducer_rebate_amount, total: introducer.wallet_total + introducer_rebate_amount, user_id: introducer.id) if introducer
		# 客户扣折
		# WalletLog.create(transfer: 2, state: 1, amount: saler_rate_amount, total: saler.wallet_total + saler_rate_amount, user_id: saler.id)
	end

	def saler
		User.find_by_id saler_id
	end

	def customer

	end

	def introducer
		User.find_by_id introducer_id
	end

end
