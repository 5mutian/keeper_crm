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
	# 
	def update_cgj
		account_info = params[:customer][:account_info]
		account = Account.find_or_initialize_by(cgj_id: account_info[:id])
		account.name = account_info[:name]
		account.reg_address = account_info[:address]
		account.save
		
		account_manager = params[:customer][:account_manager]

		if account_manager
			aadmin = User.find_or_initialize_by(mobile: account_manager[:tel])
			if aadmin.new_record?
				aadmin.password_digest = account_manager[:password_digest]
				aadmin.name = account_manager[:name]
			end
			aadmin.cgj_user_id = account_manager[:id]
			aadmin.role = 'admin'
			aadmin.account = account_info
			aaadmin.save
		end

		company = Company.find_or_initialize_by(cgj_id: params[:customer][:id])
		company.name = params[:customer][:name]
		company.address = params[:customer][:address]
		company.parent_id = account.id
		c.save

		manager_info = params[:customer][:manager_info]
		if manager_info
			cadmin = User.find_or_initialize_by(mobile: manager_info[:tel])
			if cadmin.new_record?
				cadmin.password_digest = manager_info[:manager_info]
				cadmin.name = manager_info[:real_name]
			end
			cadmin.cgj_user_id = manager_info[:id]
			cadmin.role = 'admin'
			cadmin.account = company
			cadmin.save
		end

		unless account.admin
			cadmin.account = account
			cadmin.save
		end

		render json: {msg: :ok, code: 200}
	end

	private

	def user_params
	 params[:user].permit(:name, :mobile, :role, :saler_director_id)
	end


	
end