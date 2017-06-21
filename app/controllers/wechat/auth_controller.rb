# 微信
class Wechat::AuthController < Wechat::BaseController

  # 授权
  # 
  # Params
  #   code: [String] code
  # Return
  # Error
  #   status: [String] failed
  def login
    raise '无效的code' unless params[:code]
    ok, result = User.wechat_token(params[:code])
    if ok
      render json: {result: result, code: 200, msg: :ok}
    else
      render json: {msg: result, code: 422}
    end

    rescue => e
      render json: {status: :failed, msg: e.message}
  end

end
