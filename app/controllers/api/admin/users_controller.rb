class Api::Admin::UsersController < Api::BaseController
	def index
		render json: {notice: :ok}
	end
end