require 'redis'
require 'connection_pool'

REDIS_POOL = ConnectionPool.new(size: ENV.fetch("REDIS_POOL_SIZE", 25).to_i) do
  Redis.new(
    url: ENV["REDIS_URL"],
    timeout: 1,
    reconnect_attempts: 3,
    reconnect_delay: 0.1,
    reconnect_delay_max: 0.5
  )
end

$redis = Redis.new(url: ENV["REDIS_URL"])