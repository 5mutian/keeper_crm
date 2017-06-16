# 预备信息
class Api::PresController < Api::BaseController
	skip_before_filter :valid_permission
	# 获取
	# 
	# Params
	# 	access_token: [String] authenication_token
	# Return
	# 	status: [String] success
	# 	stores_tree: [Hash] stores_tree
	# 	regions: [Hash] regions
	# 	msg: [String] 成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def index
		render json: {status: :success, stores_tree: @account.stores_tree, regions: @account.regions}
	end

end