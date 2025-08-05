require "sidekiq"

# Heroku generates a rediss URL but since
# the SSL certificate is self-signed, verification throws an error.
Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end
