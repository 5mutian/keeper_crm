# 线索管理
class Api::CluesController < Api::BaseController
	before_filter :get_clue, only: [:update, :destroy, :create_order]

	# 线索列表
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
		clues = @current_user.clues.page(params[:page])

		render json: {status: :success, list: clues, total: clues.count}
	end

	# 创建线索
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	clue[name]: [String] 姓名
	# 	clue[mobile]: [String] 手机号
	# 	clue[address]: [String] 地址
	# 	clue[remark]: [String] 备注
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def create
		clue = Clue.new(clue_params)
		clue.user = @current_user
		clue.account_id = @current_user.account_id

		if clue.save
			render json: {status: :success, msg: '创建成功'}
    else
    	render json: {status: :failed, msg: clue.errors.messages.values.first}
		end
	end

	# 更新线索
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	clue[name]: [String] 姓名
	# 	clue[mobile]: [String] 手机号
	# 	clue[address]: [String] 地址
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def update
		if @clue.update_attributes(clue_params)
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @clue.errors.messages.values.first}
		end
	end

	# 删除线索
	#
	# Params
	# 	access_token: [String] authenication_token
	# Return
	# 	status: [String] success
	# 	msg: [String] 删除成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def destroy
		if @clue.destroy
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @clue.errors.messages.values.first}
		end
	end

	private

	def clue_params
		params[:clue].permit(:name, :mobile, :address, :remark)
	end

	def order_params
		params[:order].permit(:expected_square, :booking_date, :cgj_company_id, :material, :material_id)
	end

	def owner_params
		{user_id: @current_user.id, account_id: @current_user.account_id}
	end

	def get_clue
		@clue = Clue.find(params[:id])
		raise 'not found' unless @clue
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

end