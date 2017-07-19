# 线索管理
class Api::CluesController < Api::BaseController
	skip_before_filter :valid_permission, only: [:assign, :update_me, :add_remark]
	before_filter :get_clue, only: [:update_me, :destroy, :add_remark]

	# 线索列表
	# 
	# Params
	# 	access_token: [String] authenication_token
	# 	type: [String] assign被指定
	#   page: [Integer] 页码
	# Return
	# 	status: [String] success
	#   list: [Hash] {{name, mobile, role}...}
	#   total: [Integer] 总数
	# Error
	#   status: [String] failed
	def index
		if params[:type] == 'assign'
			clues = @current_user.assign_clues.order(pound: :desc, updated_at: :desc).page(params[:page])
		else
			clues = @current_user.clues.includes(:assign_user).order(pound: :desc, updated_at: :desc).page(params[:page])
		end

		render json: {status: :success, list: clues.map(&:to_hash), total: clues.total_count, assign_users: @account.users.collect{|ele| {id: ele.id, name: ele.name}}}
	end

	# 创建线索
	#
	# Params
	# 	access_token: [String] authenication_token
	# 	clue[name]: [String] 姓名
	# 	clue[mobile]: [String] 手机号
	# 	clue[address]: [String] 地址
	#   clue[pound]: [Integer] 优先级
	# 	clue[remark]: [String] 备注
	# Return
	# 	status: [String] success
	# 	msg: [String] 创建成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def create
		clue = Clue.new(clue_params.merge(owner_params))

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
	#   id: [Integer] ID
	# 	clue[name]: [String] 姓名
	# 	clue[mobile]: [String] 手机号
	# 	clue[address]: [String] 地址
	#   clue[pound]: [Integer] 优先级
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def update_me
		if @clue.update_attributes(clue_params)
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @clue.errors.messages.values.first}
		end
	end

	# 备注
	#
	# Params
	# 	access_token: [String] authenication_token
	#   id: [Integer] ID
	# 	remark: [String] 备注内容
	# Return
	# 	status: [String] success
	# 	msg: [String] 更新成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos	
	def add_remark
		@clue.remark += params[:remark]
		if @clue.save
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
		raise '您不是线索所有者，无法删除' if @clue.user != @current_user
		if @clue.destroy
			render json: {status: :success, msg: '更新成功'}
    else
    	render json: {status: :failed, msg: @clue.errors.messages.values.first}
		end
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	# 分配线索
	#
	# Params
	# 	access_token: [String] authenication_token
	#   clue_ids: [Array] 线索列表
	# 	assign_user_id: [Integer] 指定用户id
	# Return
	# 	status: [String] success
	# 	msg: [String] 删除成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def assign
		clues = Clue.where(id: params[:clue_ids])

		raise '无法进行此操作' if clues.map(&:user_id).uniq != [@current_user.id]

		clues.update_all(assign_user_id: params[:assign_user_id])

		render json: {status: :success, msg: '更新成功'}
		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	private

	def clue_params
		params[:clue].permit(:name, :mobile, :address, :pound, :remark)
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