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

	 		signature = PingxxExtend.signature(charge, 'https://1.iujessica.applinzi.com/weixin_bang.php')

	 		render json: {status: :success, data: {charge: charge, signature: signature}}
	 	else
	 		render json: {status: :failed, msg: '重新提交' }
	 	end
 	end

 	# 提现
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   amount: [Integer] 金额
	# Return
	# 	status: [String] success
	# Error
	#   status: [String] failed
 	def withdraw
 	end

end