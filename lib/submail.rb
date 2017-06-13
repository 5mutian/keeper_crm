require 'rest-client'

module Submail

	OPTS = {appid: APP_CONFIG['submail_appid'], signature: APP_CONFIG['submail_signature']}

  def self.send(sub={}, project="code")
  	options = OPTS.merge(sub)
    RestClient.post("https://api.submail.cn/message/xsend", options.to_json,  content_type: :json, accept: :json)
  end

end