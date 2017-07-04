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
      # update_deposit_log
      wlog.update!(state: 1)
    end
	end

end