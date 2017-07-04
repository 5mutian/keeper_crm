class PaymentsController < ApplicationController

	def callback
		if params['is_success'] == 'T'
			wlog = WalletLog.find_by_id(params['out_trade_no'].delete('wallet'))
			finish_reward(wlog)
			render text: "success"
		else
			render text: "failed"
		end
	end


	private

	def finish_reward(wlog)
		WalletLog.transaction do
      tip = Tip.find_by_id(wlog.transfer_id)
      raise ActiveRecord::RecordNotFound if tip.nil?
      # update_deposit_log
      wlog.update!(state: 1, total: (wlog.user.wallet_total + wlog.amount).round(2))
    end
	end

end