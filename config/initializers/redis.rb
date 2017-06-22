  $redis = Redis::Namespace.new(
    ENV["redis_namespace"],
    redis: Redis.new(
      host: ENV["redis_server"], 
      port: ENV["redis_port"],
      password: ENV["redis_pass"],
      db: 12))
