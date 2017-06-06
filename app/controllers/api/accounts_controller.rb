# 品牌商/经销商管理
class Api::AccountsController < Api::BaseController
	
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
		render json: {status: :success, list: @account.send("#{@account.type.downcase}_hash".to_sym)}
	end

	# 添加品牌
	# 
	# Params
	# 	access_token: [String] authenication_token

	# Return
	# 	status: [String] success
	# 	msg: [String] 请求成功，等待审核
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def add_company
		raise '无权操作' if @account.type != 'Account'

		

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

		Account.where(type: 'Company', id: params[:company_ids]).each do |c|
			Apply.create(
				user_id: @current_user.id,
				target_user_id: c.admin.id,
				resource_name: 'Company',
				resource_id: c.id,
				_action: 'cooperate'
			)
		end
		render json: {status: :success, msg: '请求已发出，等待品牌商回应'}
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

end