# 用户管理
class Api::Admin::UsersController < Api::BaseController

	# 列表
	# 
	# Params:
	#   
	# Return:
	#   list:
	#  		name: [String] 姓名
	# 		mobile: [String] 手机 
	# Error:
	#   info: [String] 自己定义的错误信息
	#   other: [String] 如果不设置的，将生成默认的
	def index
		render json: {notice: :ok}
	end
end