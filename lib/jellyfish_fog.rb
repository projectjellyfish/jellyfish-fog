require 'fog'
require 'bcrypt'
require 'jellyfish_fog/engine'
require 'jellyfish_fog/provisioner'
require 'jellyfish_fog/infrastructure'
require 'jellyfish_fog/databases'
require 'jellyfish_fog/storage'

module Jellyfish
  module Fog
    module AWS
      def self.aws_settings
        {
            aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
            aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
        }
      end
    end
  end
end
