# 微信
class Api::WechatController < Api::BaseController
  skip_before_filter :authenticate_user
  skip_before_filter :valid_permission

  # 授权
  # 
  # Params
  #   code: [String] code
  # Return
  # Error
  #   status: [String] failed
  def auth
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
