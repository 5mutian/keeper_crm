# 错误码
class Api::ErrorsController < Api::BaseController

	# 说明
	#   
	# Params:
	#  	1000: [Integer] 无权限
	# 	1001: [Integer] 用户不存在
	# 	1002: [Integer] 注册成功 
	# 	1010: [Integer] 企业名称已被占用
	# 	1011: [Integer] 手机号已被占用
	#
	# Return:
	#
	# Error:
	#
	def nothing
	end

end