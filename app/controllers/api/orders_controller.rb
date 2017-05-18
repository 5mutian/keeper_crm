# 订单管理
class Api::OrdersController < Api::BaseController
	# 门店列表
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   page: [Integer] 页码
	# Return
	# 	status: [String] success
	#   list: [Hash] orders list
	#   total: [Integer] 总数
	# Error
	#   status: [String] failed
	def index
		orders = @current_user.orders.includes(:customer).page(params[:page])

		render json: {status: :success, list: orders.map(&:to_hash), total: orders.count}
	end

	# 订单创建／一键下单
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	id: [integer] clue_id
	# 	order[expected_square]: [String] 面积
	# 	order[booking_date]: [String] 预约测量时间
	# 	order[cgj_company_id]: [Integer] 品牌商ID
	# 	order[material]: [String] 材料名称
	# 	order[material_id]: [Integer] 材料ID
	# 	customer[name]: [String] 客户名称
	# 	customer[tel]: [String] 手机号
	# 	customer[province]: [String] 省
	# 	customer[city]: [String] 市
	# 	customer[area]: [String] 区
	# 	customer[street]: [String] 街道
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def create
		order = Order.new(order_params.merge(owner_params))
		customer = Customer.find_or_initialize_by(tel: params[:customer][:tel])
		customer.attributes = customer.new_record? ? customer_params.merge(owner_params) : customer_params.merge(owner_params).merge(id: customer.id)
		if customer.save
			order.customer = customer
			if order.save
				render json: {status: :success, msg: '创建成功'}
			else
				render json: {status: :failed, msg: order.errors.messages.values.first}
			end
		else
			render json: {status: :failed, msg: customer.errors.messages.values.first}
		end 
	end

	def destroy
	end

	private

	def order_params
		params[:order].permit(:expected_square, :booking_date, :cgj_company_id, :material, :material_id)
	end

	def customer_params
		params[:customer].permit(:name, :tel, :province, :city, :area, :street)
	end

	def owner_params
		{user_id: @current_user.id, account_id: @current_user.account_id}
	end

end