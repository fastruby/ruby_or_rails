# frozen_string_literal: true

if Rails.env.production?
  Sentry.init do |config|
    config.breadcrumbs_logger = [ :active_support_logger ]
    config.dsn = ENV["SENTRY_DSN"]
    config.traces_sample_rate = 1.0
  end
end
