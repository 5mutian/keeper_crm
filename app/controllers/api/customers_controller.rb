# 客户管理
class Api::CustomersController < Api::BaseController
	before_filter :get_customer, only: [:update, :destroy]
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
		customers = @current_user.customers.page(params[:page])

		render json: {status: :success, list: customers, total: @current_user.customers.total_count}
	end

	# 创建客户
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	customer[name]: [String] 姓名
	# 	customer[tel]: [String] 手机号
	# 	customer[province]: [String] 省
	# 	customer[city]: [String] 市
	# 	customer[area]: [String] 区
	# 	customer[street]: [String] 街道
	# 	customer[address]: [String] 地址
	# 	customer[remark]: [String] 备注
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def create
		customer = Customer.new(customer_params)
		customer.user = @current_user
		customer.account_id = @current_user.account_id

		if customer.save
			render json: {status: :success, msg: '创建成功'}
    else
    	render json: {status: :failed, msg: customer.errors.messages.values.first}
		end
	end

	# 更新客户
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	customer[name]: [String] 姓名
	# 	customer[tel]: [String] 手机号
	# 	customer[province]: [String] 省
	# 	customer[city]: [String] 市
	# 	customer[area]: [String] 区
	# 	customer[street]: [String] 街道
	# 	customer[address]: [String] 地址
	# 	customer[remark]: [String] 备注
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def update
		if @customer.update_attributes(customer_params)
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @customer.errors.messages.values.first}
		end
	end

	private

	def customer_params
		params[:customer].permit(:name, :tel, :province, :city, :area, :street, :address, :remark)
	end

	def get_customer
		@customer = Customer.find(params[:id])
		raise 'not found' unless @customer
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

end