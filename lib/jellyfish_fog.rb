require 'azure'
require 'fog'
require 'fog/azure'
require 'bcrypt'
require 'jellyfish_fog/engine'
require 'jellyfish_fog/provisioner'
require 'jellyfish_fog/infrastructure'
require 'jellyfish_fog/databases'
require 'jellyfish_fog/storage'

module Jellyfish
  module Fog
    module Azure
      def self.settings
        {
          provider: 'Azure',
          azure_sub_id: ENV.fetch('JELLYFISH_AZURE_SUB_ID'),
          azure_pem: ENV.fetch('JELLYFISH_AZURE_PEM_PATH'),
          azure_api_url: ENV.fetch('JELLYFISH_AZURE_API_URL')
        }
      end
    end
    def self.aws_settings
      {
        aws_access_key_id: ENV.fetch('JELLYFISH_AWS_ACCESS_KEY_ID'),
        aws_secret_access_key: ENV.fetch('JELLYFISH_AWS_SECRET_ACCESS_KEY')
      }
    end
  end
end
