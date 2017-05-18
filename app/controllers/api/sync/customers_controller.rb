# 客户同步
class Api::Sync::CustomersController < Api::Sync::BaseController
	
	# 创建客户 host: http://10.25.2.113:3000
	#
	# Params
	# 	actoken: [String] *account code
	# 	customer[name]: [String] *姓名
	# 	customer[tel]: [String] *手机号
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
		customer.account = @account
		customer.user = @account.admin

		if customer.save
			render json: {status: :success, msg: '创建成功'}
    else
    	render json: {status: :failed, msg: customer.errors.messages.values.first}
		end
	end

	private

	def customer_params
		params[:customer].permit(:name, :tel, :province, :city, :area, :street, :address, :remark)
	end

end