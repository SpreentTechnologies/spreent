# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://725553e89d9594b29771dbacf8e979af@o4508053978939392.ingest.us.sentry.io/4508926831951872'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.enable_tracing = true

  config.send_default_pii = true
end
