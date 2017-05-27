# 注册
class Api::RegistrationsController < Api::BaseController
	skip_before_filter :authenticate_user
	skip_before_filter :valid_permission

	# 说明
	# 	
	# Params
	#   account[name]: [String] 企业名称
	#   account[type]: [String] 企业类型
	#   user[name]: [String] 用户姓名
	#   user[mobile]: [String] 用户手机
	#   user[password]: [String] 用户密码
	# Return
	# 	status: [String] success
	# 	msg: [String] 您已成功注册，请登录 
	# Error
	# 	status: [String] failed
	#   msg: [String] user.errors | account.errors
	def create
		# params[:account] = {:type, :name}
		account = Account.new(params[:account])

		if account.save
			# params[:user] = {:name, :mobile, :password}
			user = User.new(params[:user])
			user.account = account
			user.role    = account.company? ? 'admin' : 'saler'
			if user.save
				render json: {status: :success, msg: '您已成功注册，请登录'}
			else
				render json: {status: :failed, msg: user.errors}
			end
		else
			render json: {status: :failed, msg: account.errors}
		end
	end

end