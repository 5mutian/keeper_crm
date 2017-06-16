# 验证码
class Api::ValidCodesController < Api::BaseController
	skip_before_filter :authenticate_user
	skip_before_filter :valid_permission

	# 获取
	# 
	# Params
	# 	mobile: [String] 手机号
	# Return
	# 	status: [String] success
	# 	msg: [String] 已发送到您手机，请验证
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def create
		vcode = ValidCode.where(mobile: params[:mobile]).last
		raise '请过段时间再验证，谢谢' if vcode && vcode.updated_at.since(5.minutes) > Time.now
		
		ValidCode.create(mobile: params[:mobile], _type: 1)

		render json: {status: :success, msg: '发送成功'}

		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	# 验证
	# 
	# Params
	# 	mobile: [String] 手机号
	# 	code: [String] 验证码
	# Return
	# 	status: [String] success
	# 	msg: [String] 验证成功
	# Error
	#   status: [String] failed
	#   msg: [String] msg_infos
	def valid
		vcode = ValidCode.where(mobile: params[:mobile], code: params[:code]).last
		if vcode.state
			vcode.update_attributes(state: false)
			render json: {status: :success, msg: '验证成功'}
		else
			render json: {status: :success, msg: '验证失败'}
		end
		rescue => e
			render json: {status: :failed, msg: e.message}
	end


end