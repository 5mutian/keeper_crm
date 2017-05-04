# 注册
class Api::RegistrationsController < Api::BaseController

	# 注册:
	# 	
	# Params
	#   account[name] [String] 企业名称
	#   account[type] [String] 企业类型
	#   user[name]: [String] 用户姓名
	#   user[mobile]: [String] 用户手机
	#   user[password]: [String] 用户密码
	# Return
	# 	code: [Integer] 1002
	# Error
	# 	code: [Integer] 1010
	#   code: [Integer] 1011
	def create
		# params[:account] = {:type, :name}
		account = Account.new(params[:account])

		if account.save
			# params[:user] = {:name, :mobile, :password}
			user = User.new(params[:user])
			user.account = account
			user.role    = account.company? ? 'admin' : 'saler'
			if user.save
				render json: {status: :successed, msg: '请登录', code: 1002}
			else
				render json: {status: :failed, errors: user.errors}
			end
		else
			render json: {status: :failed, errors: user.errors}
		end
	end

end