# 用户管理
class Api::Admin::UsersController < Api::BaseController

	# 列表
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   page: [Integer] 页码
	# Return
	# 	status: [String] success
	#   list: [Hash] {{name, mobile, role}...}
	# Error
	#   status: [String] failed
	def index
		users = @user.account.users.page(params[:page])

		render json: {status: :success, list: users.map(&:to_hash)}
	end

	# 创建
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	user[name]: [String] 用户姓名
	# 	user[mobile]: [String] 用户手机号
	# 	user[role]: [String] 用户角色(saler|cs|acct)
	# 	user[password]: [String] 用户密码
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def create
		user = User.new(user_params)
		user.password = params[:user][:password]
		user.account = @user.account

		if user.save
			render json: {status: :success, msg: '创建成功'}
    else
    	render json: {status: :failed, msg: user.errors.messages.values.first}
		end
	end

	# 更新
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	user[name]: [String] 用户姓名
	# 	user[mobile]: [String] 用户手机号
	# 	user[role]: [String] 用户角色(saler|cs|acct)
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def update
		user = User.find params[:id]
		raise 'not found' unless user
		if user.update_attributes(user_params)
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: user.errors.messages.values.first}
		end

		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	def destroy
	end

	private

	def user_params
	 params[:user].permit(:name, :mobile, :role)
	end

end