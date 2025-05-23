require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { 
    url: ENV["REDIS_URL"],
    size: ENV.fetch("REDIS_POOL_SIZE", 25).to_i
  }
end

Sidekiq.configure_client do |config|
  config.redis = { 
    url: ENV["REDIS_URL"],
    size: ENV.fetch("REDIS_POOL_SIZE", 5).to_i
  }
end