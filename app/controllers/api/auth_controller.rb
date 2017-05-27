# 多方用户验证
class Api::AuthController < Api::BaseController
	skip_before_filter :valid_permission
	
	# 窗管家验证用户
	# Params
	# 	access_token: [String] authenication_token
	# Return
	# Error
	def cgj
		# res = Cgj.auth('15802162343')
		res = Cgj.access_user(@current_user.mobile)
		if JSON(res)["user"] && JSON(res)["user"]["id"]
		else
			res = Cgj.create_user(@current_user.cgj_hash)
		end

		@current_user.update_attributes(cgj_user_id: JSON(res)["user"]["id"])

		render json: {status: :success, msg: '绑定成功', current_user: @current_user, token: @current_user.t_value, menu: @current_user.right_menu[@current_user.role]}

		rescue => e
			render json: {status: :failed, msg: e.message}
	end

end