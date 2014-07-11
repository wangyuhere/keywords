Redis.current = Redis.new url: ENV['REDIS_URL']

module WithRedis
  def redis
    Redis.current
  end
end
