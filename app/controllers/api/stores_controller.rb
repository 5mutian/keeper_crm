# 渠道门店管理
class Api::StoresController < Api::BaseController
	# 门店列表
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   page: [Integer] 页码
	# Return
	# 	status: [String] success
	#   list: [Hash] {{id, name, code, contact, phone, address}...}
	#   total: [Integer] 总数
	# Error
	#   status: [String] failed
	def index
		stores = @current_user.stores.include(:channel).page(params[:page])
		render json: {status: :success, list: stores, total: stores.count}
	end

	# 创建门店
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	channel[name]: [String] 渠道名称
	#   store[name]: [String] 门店名称
	#   store[channel]: [String] 选择渠道
	#  	store[contact]: [String] 联系人
	# 	store[phone]: [String] 电话
	# 	store[address]: [String] 地址
	#  	store[product_ids]: [String] 物料
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def create
		store = Store.new(store_params)

		if params[:channel][:name]
			channel = Channel.create(name: params[:channel][:name], account_id: @current_user.account_id)
			store.channel = channel
		end

		if store.save
			render json: {status: :success, msg: '创建成功'}
    else
    	render json: {status: :failed, msg: store.errors.messages.values.first}
		end
	end

	def update
	end

	def destroy
	end

	private

	def store_params
		params[:store].permit(:name, :contact, :phone, :channel_id, :address, :product_ids)
	end

end