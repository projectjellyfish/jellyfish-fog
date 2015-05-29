require 'azure'

Azure.configure do |config|
  # Configure these 3 properties to use Storage
  config.management_certificate = ENV.fetch('JELLYFISH_AZURE_PEM_PATH')
  config.subscription_id        = ENV.fetch('JELLYFISH_AZURE_SUB_ID')
  config.management_endpoint    = ENV.fetch('JELLYFISH_AZURE_API_URL')
end