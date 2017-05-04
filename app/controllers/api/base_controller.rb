class Api::BaseController < ApplicationController
	before_filter :authenticate_user

	def authenticate_user
		p params
		@user = User.first
		# @user = User.find_by_access_token(params[:access_token])
		p params[:controller].split('/')[1] == @user.role.downcase
	end
end