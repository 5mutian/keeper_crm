class PaymentsController < ApplicationController

	def callback
		order_no = params[:data]["object"]["order_no"]
		wlog = WalletLog.find_by_id order_no.delete("wallet")
		case params[:type]
		when "charge.succeeded"
       finish_wlog(wlog)
       render text: "success"
    when "transfer.succeeded"
    	finish_wlog(wlog)
    	render text: "success"
		else
			render text: "failed"
		end
	end


	private

	def finish_wlog(wlog)
		WalletLog.transaction do
      wlog.update(state: 1)
    end
	end

end