# 客户管理
class Api::CustomersController < Api::BaseController

	# 客户列表
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   page: [Integer] 页码
	# Return
	# 	status: [String] success
	#   list: [Hash] customers_hash
	#   total: [Integer] 总数
	# Error
	#   status: [String] failed
	def index
	end

	def create
	end

	def update
	end

	def destroy
	end

	private

	def customer_params
	end

end