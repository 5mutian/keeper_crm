class SessionsController < ApplicationController
  #引入SessionsHelper moudle，这样就可以调用该moudle中的方法了
  include SessionsHelper

  def new
  end

  def create
    user = User.find_by_mobile(params[:session][:mobile])
    #authenticate是has_secure_password引入的一个方法，用来判断user的密码与页面中传过来的密码是否一致
    if user && user.authenticate(params[:session][:password])
      log_in(user) #SessionsHelper中的方法
      #判断是否要持续性的记住用户的登录状态
      params[:session][:remeber_me] == "1" ? remeber(user) : forget(user)
      render json: {status: :ok, token: 'current_user_token'}
    else
      flash.now[:danger] = "Invalid login or password."
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? #SessionsHelper中的方法
    redirect_to root_path
  end
end