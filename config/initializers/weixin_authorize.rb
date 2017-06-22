namespace = "keeper:weixin_authorize"
redis = Redis.new(:host => ENV["redis_server"], :port => ENV["redis_port"], :db => 15, password: ENV["redis_pass"])

exist_keys = redis.keys("#{namespace}:*")
exist_keys.each{|key|redis.del(key)}

redis = Redis::Namespace.new("#{namespace}", redis: redis)

WeixinAuthorize.configure do |config|
  config.redis = redis
end

$wechat_client ||= WeixinAuthorize::Client.new(ENV["wechat_app_id"], ENV["wechat_app_secret"])