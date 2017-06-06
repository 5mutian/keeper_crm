# 经销商管理
class Api::DealersController < Api::BaseController
	
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

		rescue => e
			render json: {status: :failed, msg: e.message}
	end

end