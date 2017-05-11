class Api::BaseController < ApplicationController
	before_filter :authenticate_user

	skip_before_filter :verify_authenticity_token

	def authenticate_user
		# @user = User.where(role: 'admin').first
		@current_user = User.find_by_access_token(params[:access_token])
		raise '用户不存在' unless @current_user
		raise '用户已禁用' unless @current_user.is_valid?
		# raise '无权限访问' unless params[:controller].split('/')[1] == @current_user.role

		rescue => e
			render json: {status: :failed, msg: e.message}
	end
end