namespace = "keeper:weixin_authorize"
redis = Redis.new(host: "127.0.0.1", port: "6379", db: 15)

exist_keys = redis.keys("#{namespace}:*")
exist_keys.each{|key|redis.del(key)}

redis = Redis::Namespace.new("#{namespace}", redis: redis)

WeixinAuthorize.configure do |config|
  config.redis = redis
end

$wechat_client ||= WeixinAuthorize::Client.new(ENV["wechat_app_id"], ENV["wechat_app_secret"])