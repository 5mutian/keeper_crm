class Wechat::AuthController < Wechat::BaseController

  def login
    render json: {msg: "缺少参数code", code: 419} and return unless params[:code] && !params[:code].blank?
    ok, result = User.wechat_token(params[:code])
    if ok
      render json: {result: result, code: 200, msg: :ok}
    else
      render json: {msg: result, code: 422}
    end
  end

  #"user"=>{"nickName"=>"yf", "gender"=>1, "language"=>"zh_CN", "city"=>"", "province"=>"Shanghai", "country"=>"CN", "avatarUrl"=>"http://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKotwgsX9quR050r5GyqOu4QJuQaK1oFh9xMJT7SNbMwhJd5l0IswknGzhOMfh0qOohX04GzEp37A/0", "code"=>"0214u0sB0kBISc2QGssB0X18sB04u0sH", "openid"=>"o7Mf50KlIreytnOlNvG94egyOg10"}
  def wechat_user
    if params[:user] && !params[:user].blank?
      user = User.create_auth(params[:user]) 
      logger.info("#########{params[:user]}")
      token = user.generate_auth_token
      render json: {user: user, token: token, code: 200}
    end
  end
end
