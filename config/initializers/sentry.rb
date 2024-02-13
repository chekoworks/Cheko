Sentry.init do |config|
  config.dsn = 'https://1c3522179f0ab2dc8740596987fb20bc@o4506739725500416.ingest.sentry.io/4506739727138816'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.environment = 'production'

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
