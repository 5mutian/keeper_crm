class Api::BaseController < ApplicationController
	before_filter :authenticate_user

	def authenticate_user
		# @user = User.where(role: 'Admin').first
		@user = User.find_by_access_token(params[:access_token])
		raise '1001' unless @user
		raise '1000' unless params[:controller].split('/')[1] == @user.role.downcase

	end
end