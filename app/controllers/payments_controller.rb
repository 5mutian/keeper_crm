class PaymentsController < ApplicationController

	def callback
		case params[:type]
		when "charge.succeeded"
			begin
        wlog = WalletLog.find_by_id params['order_no'].delete("wallet")
        finish_charge(wlog) if wlog
        render text: "success"
      rescue
        render text: "fail"
      end
    when "transfer.succeeded"
    	wlog = WalletLog.find_by_id params['order_no'].delete("wallet")
    	finish_transfer(wlog) if wlog
    	
    	###############
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