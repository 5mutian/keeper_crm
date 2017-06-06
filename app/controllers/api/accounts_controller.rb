# 企业管理
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
		render json: {status: :success, list: @account.children.map(&:list_hash)}
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
	end

end