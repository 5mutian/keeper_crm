# 策略管理
class Api::StrategiesController < Api::BaseController
	before_filter :get_strategy, only: [:update, :show]

	# 策略列表
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   page: [Integer] 页码
	# Return
	# 	status: [String] success
	#   list: [Hash] {{name, mobile, role}...}
	#   total: [Integer] 总数
	# Error
	#   status: [String] failed
	def index
		clues = @current_user.account.strategies.order(pound: :desc, updated_at: :desc).page(params[:page])

		if params[:page].to_i < 2
			render json: {status: :success, list: clues, total: clues.count, regions: @current_user.account.regions.map(&:select_hash)}
		else
			render json: {status: :success, list: clues, total: clues.count}
		end
	end

	# 创建策略
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   strategy[title]: [String] 主题
	#   strategy[start_at]: [DateTime] 开始时间
	#   strategy[end_at]: [DateTime] 结束时间
	#  	strategy[province]: [String] 省
	# 	strategy[city]: [String] 市
	# 	strategy[area]: [String] 区
	# 	strategy[region_id]: [Integer] 渠道
	#   strategy[rate]: [Float] 提成
	#   strategy[discount]: [Float] 折扣
	# 	strategy[rebate]: [Float] 返利
	# 	strategy[pound]: [Integer] 镑值
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] strategy.errors
	def create
		strategy = Strategy.new(strategy_params)
		strategy.account = @current_user.account

		if strategy.save
			render json: {status: :success, msg: '创建成功'}
    else
    	render json: {status: :failed, msg: strategy.errors.messages.values.first}
		end
	end

	# 更新策略
	# 
	# Params
	# 	access_token: [String] authenication_token
	#   strategy[title]: [String] 主题
	#   strategy[start_at]: [DateTime] 开始时间
	#   strategy[end_at]: [DateTime] 结束时间
	#   strategy[rate]: [Float] 提成
	#   strategy[discount]: [Float] 折扣
	# 	strategy[rebate]: [Float] 返利
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] strategy.errors
	def update
		raise 'not update' unless @strategy.state
		raise 'not update' unless @strategy.start_at
		raise 'not update' unless DateTime.now < @strategy.start_at

		@strategy.update_attributes(strategy_params)
		
		render json: {status: :success, msg: '更新成功'}
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	# 查看单个策略
	# 
	# Params
	# 	access_token: [String] authenication_token
	# Return
	# 	status: [String] success
	# 	strategy: [Hash] strategy_hash
	# Error
	#   status: [String] failed
	#   msg: [String] strategy.errors
	def show
		render json: {status: :success, strategy: @strategy}
	end

	private

	def get_strategy
		@strategy = Strategy.find(params[:id])
		raise 'not found' unless @strategy
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	def strategy_params
		params[:strategy].permit(:start_at, :end_at, :rate, :discount, :rebate, :title, :province, :city, :area, :region_id, :pound)
	end

end