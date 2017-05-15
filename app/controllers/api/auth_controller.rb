# 多方用户验证
class Api::AuthController < Api::BaseController

	# 窗管家
	# Params
	# 	mobile: [String] 用户手机号
	# Return
	# Error
	def cgj
		res = Cgj.auth(@current_user.mobile)
	end

end