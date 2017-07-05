class HomeController < ApplicationController

	def index
		render json: {msg: 'welcome'}
	end

end