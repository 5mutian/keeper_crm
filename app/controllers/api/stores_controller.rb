# 渠道门店管理
class Api::StoresController < Api::BaseController
	before_filter :get_store, only: [:update, :update_products]
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
		stores = @current_user.account.stores.page(params[:page])
		render json: {status: :success, list: stores, total: stores.count, regions: @current_user.account.regions}
	end

	# 创建门店
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	region[name]: [String] 渠道名称
	#   store[name]: [String] 门店名称
	#   store[region_id]: [String] 选择渠道
	#  	store[contact]: [String] 联系人
	# 	store[phone]: [String] 电话
	# 	store[address]: [String] 地址
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def create
		store = Store.new(store_params)

		if params[:region][:name]
			region = Region.create(name: params[:region][:name], account_id: @current_user.account_id)
			store.region = region
			store.account = channel.account
		end

		if store.save
			render json: {status: :success, msg: '创建成功'}
    else
    	render json: {status: :failed, msg: store.errors.messages.values.first}
		end
	end

	# 更新门店
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	region[name]: [String] 渠道名称
	#   store[name]: [String] 门店名称
	#   store[channel]: [String] 选择渠道
	#  	store[contact]: [String] 联系人
	# 	store[phone]: [String] 电话
	# 	store[address]: [String] 地址
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def update
		if params[:region][:name]
			region = Region.create(name: params[:region][:name], account_id: @current_user.account_id)
			store_params[:region_id] = region.id
		end

		if @store.update_attributes(store_params)
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @store.errors.messages.values.first}
		end
	end

	# 更新物料库
	# 
	# Params
	# 	access_token: [String] authenication_token
	# 	product_ids: [Array] 物料ids
	# Return
	# 	status: [String] success
	# 	store:  [Hash] store
	#   products: [Hash] products_hash
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def update_products
		@store.update_attributes(product_ids: params[:product_ids])

		render json: {status: :success, store: @store, products: @store.proeducts_hash, msg: '更新成功'}
	end

	def destroy
	end

	private

	def store_params
		params[:store].permit(:name, :contact, :phone, :region_id, :address)
	end

	def get_store
		@store = @current_user.account.stores.find(params[:id])
		raise 'not found' unless @store
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

end