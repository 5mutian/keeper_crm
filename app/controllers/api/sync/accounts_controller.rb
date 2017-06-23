# 获取企业信息
class Api::Sync::AccountsController < Api::Sync::BaseController

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
	# 
	def update_cgj
		company = Company.find_or_initialize_by(cgj_id: params['result']['id'])
		company.name = params['result']['name']
		company.address = params['result']['address']
		company.parent_id = Account.find_by_cgj_id(params['result']['account_id']).try(:id)
		c.save

		manager = params['result']['manager']
		if manager
			cadmin = User.find_or_initialize_by(mobile: manager['tel'])
			if cadmin.new_record?
				cadmin.password_digest = manager['password_digest']
				cadmin.name = manager['real_name']
			end
			cadmin.cgj_user_id = manager['id']
			cadmin.role = 'admin'
			cadmin.account = company
			cadmin.save
		end

		render json: {msg: :ok, code: 200}
	end

	private

	def user_params
	 params[:user].permit(:name, :mobile, :role, :saler_director_id)
	end


	
end