module ExtraPingxx
  class << self


    def url
      "https://api.pingxx.com/v1/batch_transfers"
    end

    def batch_transfers(options={})
      options = options.merge(app: ENV["pingpp_app_id"])
      RestClient::Request.execute({
        method: :post,
        url: url,
        user: ENV["pingpp_api_key"],
        payload: JSON::dump(options),
        headers: {
          Pingplusplus_Signature: signature(options),
          Pingplusplus_Request_Timestamp: Time.now.to_i.to_s,
          Content_Type: 'application/json',
          charset: "utf-8"
        }
      })
    end

    def batch_options
      args = {
        app: ENV["pingpp_app_id"],
        batch_no: Time.now.strftime("%Y%m%d%M%H%S"),
        channel: "alipay",
        amount: 100,
        description: "ssss",
        type: "b2c",
        recipients: [
          account: "yeyong14@126.com",
          amount: 100,
          name: "计算机"
        ]
      }
      args
    end

    def common_args(options={})
      time = Time.now.to_i.to_s
      body = JSON::dump(options)
      uri = "/v1/batch_transfers"
      return body, uri, time
    end

    def signature(options={})
      temp = common_args(options).join("")
      hash = OpenSSL::Digest::SHA256.new
      pkey = OpenSSL::PKey::RSA.new(File.read("#{Rails.root}/private_key.pem"))
      Base64.strict_encode64(pkey.sign(hash, temp))
    end
  end
end