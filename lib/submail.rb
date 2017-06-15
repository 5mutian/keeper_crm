require 'rest-client'

module Submail

	OPTS = {appid: ENV['submail_appid'], signature: ENV['submail_signature']}

  def self.send(sub={}, project="code")
  	options = OPTS.merge(sub)
    RestClient.post("https://api.submail.cn/message/xsend", options.to_json,  content_type: :json, accept: :json)
  end

end