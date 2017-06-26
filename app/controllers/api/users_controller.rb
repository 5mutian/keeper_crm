# 用户管理
class Api::UsersController < Api::BaseController
	skip_before_filter :valid_permission, except: [:update_me]
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
		users = @account.users.includes(:children).where(status: 1).page(params[:page])

		render json: {status: :success, list: users.map(&:to_hash), total: users.total_count}
	end

	# 用户创建
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	user[name]: [String] 用户姓名
	# 	user[mobile]: [String] 用户手机号
	# 	user[role]: [String] 用户角色(saler_director|saler|cs|acct)
	# 	user[saler_director_id]: [Integer] 销售主管
	# 	user[password]: [String] 用户密码
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def create
		raise '无效的手机号' unless user_params[:mobile].match(/^1[3|4|5|8][0-9]\d{4,8}$/)
		user = User.new(user_params)
		user.password = params[:user][:password]
		user.account = @current_user.account

		if user.save
			render json: {status: :success, msg: '创建成功'}
    else
    	render json: {status: :failed, msg: user.errors.messages.values.first}
		end
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	# 用户更新
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	user[name]: [String] 用户姓名
	# 	user[mobile]: [String] 用户手机号
	# 	user[role]: [String] 用户角色(saler_director|saler|cs|acct)
	# 	user[saler_director_id]: [Integer] 销售主管
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

	# 更新我的基本资料
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	user[name]: [String] 姓名
	# 	user[avatar]: [String] 头像
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def update_me
		if @current_user.update_attributes(my_params)
			render json: {status: :success, current_user: @current_user.infos, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @current_user.errors.messages.values.first}
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
		raise '不能删除自己' if @current_user == @user
		if @user.update_attributes(status: -1)
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @user.errors.messages.values.first}
		end
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	private

	def user_params
	 params[:user].permit(:name, :mobile, :role, :saler_director_id)
	end

	def my_params
		params[:user].permit(:name, :avatar)
	end

	def get_user
		@user = User.find(params[:id])
		raise 'not found' unless @user
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

end