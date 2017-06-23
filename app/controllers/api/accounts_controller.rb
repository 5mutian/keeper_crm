# 品牌商/经销商管理
class Api::AccountsController < Api::BaseController

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
	
	# 品牌列表
	# 
	# Params
	# 	access_token: [String] authenication_token
	# Return
	# 	status: [String] success
	# 	msg: [String] 请求成功，等待审核
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def companies
		case @account.type
		when 'Dealer'
			render json: {status: :success, list: @account.dealer_hash, select_list: @account.unco_companies}
		when 'Company'
			render json: {status: :success, list: @account.co_applies}
		else
			render json: {status: :success, list: @account.account_hash}
		end
	end

	# 添加品牌
	# 
	# Params
	# 	access_token: [String] authenication_token
  #   company[name]: [String] 品牌名
  # 	company[logo]: [File] 品牌logo
  #   admin[name]:   [String] 管理员姓名
  #   admin[mobile]: [String] 管理员手机号
  #   admin[password]: [String] 管理员密码
	# Return
	# 	status: [String] success
	# 	msg: [String] 请求成功，等待审核
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def add_company
		raise '无权操作'			unless @account.type == 'Account'
		raise '无效的手机号'		unless admin_params[:mobile].match(/^1[3|4|5|8][0-9]\d{4,8}$/)
		raise '名称已被占用'		if Account.where(name: company_params[:name]).count > 0
		raise '手机号已被占用' if User.find_by(mobile: admin_params[:mobile]).try(:account_id).to_i > 0

		Company.transaction do
			User.transaction do
				company      = Company.find_or_initialize_by(name: company_params[:name], parent_id: @account.id)
				company.logo = company_params[:logo]
				company.save

				user = User.find_or_initialize_by(mobile: admin_params[:mobile])
				user.name = admin_params[:name]
				user.password = admin_params[:password]
				user.role = 'admin'
				user.account_id = company.id
				user.save
				
				company.sync_cgj
			end
		end

		render json: {status: :success, msg: '创建成功'}

		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	# 申请品牌合作
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   company_ids: [Array] 品牌商数组
	# Return
	# 	status: [String] success
	# 	msg: [String] 请求成功，等待审核
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def apply_co_companies
		raise '无权操作' if @account.type != 'Dealer'
		raise 'not found' if params[:company_ids].empty?

		Company.where(id: params[:company_ids]).each do |c|
			a = Apply.find_or_initialize_by(user_id: @current_user.id, resource_name: 'Company', resource_id: c.id, _action: 'cooperate', state: 0)
			a.target_user_id = c.admin.id
			a.save
		end
		render json: {status: :success, msg: '请求已发出，等待品牌商回应'}
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	# 更新申请状态
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   apply_id: [Integer] 合作请求的id
	# 	state: [Integer] 状态(1|-1)
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def update_apply
		raise '参数出错' unless [1, -1].include?(params[:state].to_i)
		apply = Apply.find params[:apply_id]
		raise '未找到请求' unless apply
		raise '无权操作' if apply.target_user != @current_user

		if apply.update_attributes(state: params[:state].to_i)
			if apply.state == 1
				co_dealer = apply.user.account
				co_dealer.company_ids = Array(co_dealer.company_ids) << apply.resource_id
				co_dealer.save
			end
			render json: {status: :success, msg: '更新成功'}
		else
			render json: {status: :failed, msg: company.errors}
		end

		rescue => e
			render json: {status: :failed, msg: e.message}
	end


	# 更新企业资料
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	account[name]: [String] 企业名称
	# 	account[address]: [String] 企业地址
	# 	account[logo]: [File] 企业图片
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def update_me
		raise '无权操作' unless @current_user != @account.admin
		if @account.update_attributes(account_params)
			render json: {status: :success, account: @account, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @account.errors.messages.values.first}
		end
		rescue => e
			render json: {status: :failed, msg: e.message}
	end


	private

	def account_params
		params[:account].permit(:name, :address, :logo)
	end

	def company_params
		params[:company].permit(:name, :logo)
	end

	def admin_params
		params[:admin].permit(:name, :mobile, :password)
	end

end