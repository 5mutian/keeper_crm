# 多方用户验证
class Api::AuthController < Api::BaseController
	# skip_before_filter :authenticate_user
	
	# 窗管家验证用户
	# Params
	# 	mobile: [String] 用户手机号
	# Return
	# Error
	def cgj
		# res = Cgj.auth('15802162343')
		res = Cgj.auth(@current_user.mobile)
		if JSON(res)["user"]["id"]
			@current_user.update_attributes(cgj_user_id: JSON(res)["user"]["id"])
		else
			render json: {status: :success, msg: '绑定成功'}
		end

		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	
	def cgj_create_user
	end

end