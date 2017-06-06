# 注册
class Api::RegistrationsController < Api::BaseController
	skip_before_filter :authenticate_user
	skip_before_filter :valid_permission

	# 说明
	# 	
	# Params
	#   account[name]: [String] 企业名称
	#   account[type]: [String] 企业类型(Account|Dealer)
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
		raise '企业类型错误' unless ['Account', 'Dealer'].include?(params[:account][:type])
		raise '手机号已被使用' unless User.where(mobile: user_params[:mobile]).empty?

		account = Account.new(account_params)

		if account.save
			user = User.new(user_params)
			user.account = account
			user.role    = 'admin'
			if user.save
				render json: {status: :success, msg: '您已成功注册，请登录'}
			else
				render json: {status: :failed, msg: user.errors}
			end
		else
			render json: {status: :failed, msg: account.errors}
		end

		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	private

	def account_params
		params[:account].permit(:name, :type)
	end

	def user_params
		params[:user].permit(:name, :mobile, :password)
	end

end