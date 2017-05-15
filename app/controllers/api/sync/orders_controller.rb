# 订单同步
class Api::Sync::OrdersController < Api::Sync::BaseController
	
	# 创建
	def create
		render json: {status: :ok}
	end

end