class Api::Sync::BaseController < ApplicationController
	# before_filter :cgj_user
	before_filter :valid_account

	skip_before_filter :verify_authenticity_token

	def cgj_user
		# @user = User.where(role: 'admin').first
		@current_user = User.find_by_cgj_token(params[:access_token])
		raise '用户不存在' unless @current_user
		raise '用户已禁用' unless @current_user.is_valid?

		rescue => e
			render json: {status: :failed, msg: e.message}
	end

	def valid_account
		@account = Account.includes(:admin).find_by_code(params[:actoken])
		raise '验证出错' unless @account

		rescue => e
			render json: {status: :failed, msg: e.message}
	end
end