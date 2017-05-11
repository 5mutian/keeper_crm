# 用户管理
class Api::UsersController < Api::BaseController
	before_filter :get_user, only: [:update, :destroy]
	# 用户列表
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   page: [Integer] 页码
	# Return
	# 	status: [String] success
	#   list: [Hash] {{name, mobile, role}...}
	#   total: [Integer] 总数
	# Error
	#   status: [String] failed
	def index
		users = @current_user.account.users.page(params[:page])

		render json: {status: :success, list: users.map(&:to_hash), total: users.count}
	end

	# 用户创建
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
		user.account = @current_user.account

		if user.save
			render json: {status: :success, msg: '创建成功'}
    else
    	render json: {status: :failed, msg: user.errors.messages.values.first}
		end
	end

	# 用户更新
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
		if @user.update_attributes(user_params)
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @user.errors.messages.values.first}
		end
	end

	# 用户删除
	#
	# Params
	# 	access_token: [String] authenication_token
	# Return
	# 	status: [String] success
	# 	msg: [String] 删除成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def destroy
		if @user.update_attributes(status: -1)
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @user.errors.messages.values.first}
		end
	end

	private

	def user_params
	 params[:user].permit(:name, :mobile, :role)
	end

	def get_user
		@user = User.find(params[:id])
		raise 'not found' unless @user
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

end