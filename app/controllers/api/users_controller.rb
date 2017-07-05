# 用户管理
class Api::UsersController < Api::BaseController
	skip_before_filter :valid_permission, only: [:update_me, :update_password, :add_bank_card, :update_bank_card]
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
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def create
		raise '无效的手机号' unless user_params[:mobile].match(/^1[3|4|5|8][0-9]\d{4,8}$/)
		user = User.new(user_params)
		user.password = ENV['init_ps']
		user.account = @current_user.account

		if user.save
			user.send_sms # notice to user
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

	# 更新密码
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	old_password: [String] 旧密码
	# 	new_password: [String] 新密码
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def update_password
		if @current_user.authenticate(params[:old_password])
			@current_user.update(password: params[:new_password])
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: '请输入正确的旧密码'}
		end
	end

	# 添加银行卡
	#
	# Params
	# 	access_token: [String] authenication_token
	#   bank_card[code]: [String] 银行卡号
	# 	bank_card[account]: [String] 开户行
	# 	bank_card[branch]: [String] 支行
	# 	bank_card[name]: [String] 开户人
	# Return
	# 	status: [String] success
	# 	msg: [String] 添加成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def add_bank_card
		bank_card = @current_user.bank_cards.new(bank_card_params)
		if bank_card.save
			render json: {status: :success, msg: '添加成功'}
    else
    	render json: {status: :failed, msg: bank_card.errors.messages.values.first}
		end

		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	# 更新银行卡
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	id: [Integer] 银行卡ID
	#   bank_card[code]: [String] 银行卡号
	# 	bank_card[account]: [String] 开户行
	# 	bank_card[branch]: [String] 支行
	# 	bank_card[name]: [String] 开户人
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def update_bank_card
		bank_card = @current_user.bank_cards.find(params[:id])
		raise '没有找到相应的银行卡' unless bank_card
		if bank_card.update_attributes(bank_card_params)
			render json: {status: :success, msg: '添加成功'}
    else
    	render json: {status: :failed, msg: bank_card.errors.messages.values.first}
		end

		rescue => e
			render json: {status: :failed, msg: e.message}
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

	def bank_card_params
		params[:bank_card].permit(:code, :account, :branch, :name)
	end

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