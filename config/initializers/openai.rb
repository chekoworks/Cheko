# Dotenv::Railtie.load # or require 'dotenv/rails-now' -> These enable the dotenv-rails gem during initialization.
require "ruby/openai"

OpenAI.configure do |config|
    config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
    # config.access_token = Rails.application.credentials.openai[:accessToken]
    # config.organization_id = ENV.fetch('OPENAI_ORGANIZATION_ID') # Optional.
end
