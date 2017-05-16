class RegistrationsController < ApplicationController

	def create
		# params[:account] = {:type, :name}
		account = Account.new(params[:account])

		if account.save
			# params[:user] = {:name, :mobile, :password}
			user = User.new(params[:user])
			user.account = account
			user.role    = account.company? ? 'admin' : 'saler'
			if user.save
				render json: {status: :successed, msg: '请登录'}
			else
				render json: {status: :failed, errors: user.errors}
			end
		else
		end
	end

end