module PingxxExtend
  class << self

    def ticket
      ticket = $redis.get('pingpp_jsapi_ticket')
      unless ticket
        jsapi_ticket = Pingpp::WxPubOauth.get_jsapi_ticket(ENV["wechat_app_id"], ENV["wechat_app_secret"])
        $redis.setex('pingpp_jsapi_ticket', 7200, jsapi_ticket['ticket'])
      end
      ticket = $redis.get('pingpp_jsapi_ticket')
    end

    def signature(charge, url)
      Pingpp::WxPubOauth.get_signature(charge, ticket, url)
    end

    def wx_noncestr
      '1c62ef34ed3c8c7807d4dcb36d5defe3'
    end

    def wx_config
      str = "jsapi_ticket=#{ticket}&noncestr=#{wx_noncestr}&timestamp=1414587457&url=https://1.iujessica.applinzi.com/weixin_bang.php"
      Digest::SHA1.hexdigest(str)
    end

  end   
end