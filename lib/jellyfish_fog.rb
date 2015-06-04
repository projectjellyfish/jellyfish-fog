require 'rbvmomi'
require 'azure'
require 'fog'
require 'fog/azure'
require 'bcrypt'
require 'jellyfish_fog/engine'
require 'jellyfish_fog/provisioner'
require 'jellyfish_fog/infrastructure'
require 'jellyfish_fog/security_group'
require 'jellyfish_fog/database'
require 'jellyfish_fog/storage'
require 'jellyfish_fog/subnet'
require 'jellyfish_fog/vpc'
require 'jellyfish_fog/ebs'

module Jellyfish
  module Fog
    module AWS
      def self.settings
        {
          provider: 'aws',
          aws_access_key_id: ENV.fetch('JELLYFISH_AWS_ACCESS_KEY_ID'),
          aws_secret_access_key: ENV.fetch('JELLYFISH_AWS_SECRET_ACCESS_KEY')
        }
      end
    end
    module VMWare
      def self.settings
        {
          provider: 'vsphere',
          vsphere_username: ENV.fetch('JELLYFISH_VMWARE_USERNAME'),
          vsphere_password: ENV.fetch('JELLYFISH_VMWARE_PASSWORD'),
          vsphere_server: ENV.fetch('JELLYFISH_VMWARE_SERVER'),
          vsphere_expected_pubkey_hash: ENV.fetch('JELLYFISH_VMWARE_EXPECTED_PUBKEY_HASH')
        }
      end
    end
    module Azure
      def self.settings
        {
          provider: 'azure',
          azure_sub_id: ENV.fetch('JELLYFISH_AZURE_SUB_ID'),
          azure_pem: ENV.fetch('JELLYFISH_AZURE_PEM_PATH'),
          azure_api_url: ENV.fetch('JELLYFISH_AZURE_API_URL')
        }
      end
    end
  end
end
