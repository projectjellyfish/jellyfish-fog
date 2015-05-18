require 'fog'
require 'bcrypt'
require 'jellyfish_fog/engine'
require 'jellyfish_fog/provisioner'
require 'jellyfish_fog/infrastructure'
require 'jellyfish_fog/databases'
require 'jellyfish_fog/storage'

module Jellyfish
  module Fog
    def self.aws_settings
      {
        aws_access_key_id: ENV.fetch('JELLYFISH_AWS_ACCESS_KEY_ID'),
        aws_secret_access_key: ENV.fetch('JELLYFISH_AWS_SECRET_ACCESS_KEY')
      }
    end
  end
end
