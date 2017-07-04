class PaymentsController < ApplicationController

	def callback
		case params[:type]
		when "charge.succeeded"
			begin
        wlog = WalletLog.find_by_id params['order_no'].delete("wallet")
        finish_reward(wlog) if wlog
        render text: "success"
      rescue
        render text: "fail"
      end
    when "transfer.succeeded"
    	###############
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