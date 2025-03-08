require 'redis'

redis_config = {
  host: ENV.fetch('REDIS_HOST', 'localhost'),
  port: ENV.fetch('REDIS_PORT', 6379),
  timeout: 1
}

# Configure Redis as the cache store for Rails
Rails.application.config.cache_store = :redis_cache_store, redis_config

# Also make Redis available globally if needed for other purposes
$redis = Redis.new(redis_config) 