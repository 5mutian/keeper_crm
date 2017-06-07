# 获取企业信息
class Api::Sync::AccountsController < Api::Sync::BaseController

	# 获取企业销售主管信息
	#
	# Params
	# 	actoken: [String] *account code
	# Return
	# 	status: [String] success
	# 	msg: [String] 成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def get_saler_directors
		render json: {status: :success, list: @account.saler_directors.map(&:to_hash)}
	end

	# 生成企业用户
	#
	# Params
	# 	actoken: [String] *account code
	# 	user[name]: [String] *用户姓名
	# 	user[mobile]: [String] *用户手机号
	# 	user[role]: [String] *用户角色(saler_director|saler|cs|acct)
	# 	user[saler_director_id]: [Integer] 销售主管
	# 	user[password]: [String] *用户密码
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def gen_account_user
		user = User.new(user_params)
		user.password = params[:user][:password]
		user.account  = @account

		if user.save
			render json: {status: :success, msg: '创建成功, 请登录'}
    else
    	render json: {status: :failed, msg: user.errors.messages.values.first}
		end
	end

	# 同步更新品牌 host: http://192.168.0.164:7200/
	# Params
	# Return
	# Error
	def update_cgj
		account = Account.find_or_initialize_by(cgj_id: params)
	end

	private

	def user_params
	 params[:user].permit(:name, :mobile, :role, :saler_director_id)
	end


	
end