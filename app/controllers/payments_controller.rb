class PaymentsController < ApplicationController

	def callback
		order_no = params[:data]["object"]["order_no"]
		wlog = WalletLog.find_by_id order_no.delete("wallet")
		case params[:type]
		when "charge.succeeded"
       finish_charge(wlog)
       render text: "success"
    when "transfer.succeeded"
    	finish_transfer(wlog)
    	render text: "success"
		else
			render text: "failed"
		end
	end


	private

	def finish_charge(wlog)
		WalletLog.transaction do
      # update_deposit_log
      wlog.update!(state: 1)
    end
	end

	def finish_transfer(wlog)
		WalletLog.transaction do
			wlog.update!(state: 1)
			wlog.user.valid_wlog.update(total: (wlog.user.wallet_total - wlog.amount).round(2))
		end
	end

end