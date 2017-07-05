# 钱包
class Api::WalletsController < Api::BaseController
	skip_before_filter :valid_permission


	# 配置
	def config
		render json: {
    	success: :success,
    	config: {
				appId: 'wx1211e96e6c279899',
				timestamp: '1498042783',
				nonceStr: PingxxExtend.wx_noncestr,
				signature: PingxxExtend.wx_config
			}
		}
	end

	# 我的钱包
	# 
	# Params
	# 	access_token: [String] authenication_token
	# Return
	# 	status: [String] success
	# Error
	#   status: [String] failed
	def me
		render json: {status: :success, wallet: @current_user.wallet}
	end
 	
 	# 充值
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   amount: [Integer] 金额
	# 	trade_type: [String] 支付方式 wx_pub|alipay_pc_direct
	# Return
	# 	status: [String] success
	# Error
	#   status: [String] failed
 	def recharge
 		wlog = WalletLog.new(trade_type: params[:trade_type], user_id: @current_user.id, transfer: 0, state: 0, amount: params[:amount], total: @current_user.wallet_total + params[:amount].to_f)
 		if wlog.save
	 		charge = wlog.generate_pay

	 		render json: {status: :success, data: {charge: charge}}
	 	else
	 		render json: {status: :failed, msg: '重新提交' }
	 	end
 	end

 	# 提现
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   amount: [Integer] 金额
	# 	bank_card_id: [Integer] 银行卡
	# Return
	# 	status: [String] success
	# Error
	#   status: [String] failed
 	def withdraw
 		bank_card = @current_user.bank_cards.find_by_id params[:bank_card_id]

 		raise '请绑定有效银行卡' 				unless bank_card
 		raise '请输入正确的金额' 				if @current_user.wallet_total < params[:amount].to_f
 		raise '您有一笔金额正在提现中' 	if @current_user.withdraw_info[:is_withdraw]

 		WalletLog.transaction do
	 		WalletLog.create(
	 			user_id: 	@current_user.id, 
	 			transfer: 3, 
	 			amount: 	params[:amount], 
	 			total: 		@current_user.wallet_total - params[:amount].to_f, 
	 			state: 		0,
	 			# bank_card
	 			account_number: bank_card.code,
	 			account_bank:   bank_card.account,
	 			account_branch: bank_card.branch,
	 			account_name:   bank_card.name
	 		)
	    
	    WalletLog.create(
	    	user_id: 	@current_user.id,
	    	transfer: 4,
	    	amount: 	0.01,
	    	total: 		@current_user.wallet_total - params[:amount].to_f,
	    	state: 		1
	    )
	  end
    render json: {status: :success, msg: '提现审请已提交，将在三个工作日内处理完成。'}
 		rescue => e
			render json: {status: :failed, msg: e.message}
 	end

end