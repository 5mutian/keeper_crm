# 用户管理
class Api::Admin::UsersController < Api::BaseController

	# 列表
	# 
	# Params:
	# 	access_token: [String] authenication_token
	#   page: [Integer] 页码
	# Return:
	# 	status: [String] success
	#   list: [Hash] {{name, mobile, role}...}
	# Error:
	#   info: [String] 自己定义的错误信息
	#   other: [String] 如果不设置的，将生成默认的
	def index
		users = @user.account.users.page(params[:page])

		render json: {status: :success, list: users.map(&:to_hash)}
	end

	def create
	end

	def update
	end

	def destroy
	end
end