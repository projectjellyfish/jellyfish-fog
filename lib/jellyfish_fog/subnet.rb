module Jellyfish
  module Fog
    module AWS
      class Subnet < Jellyfish::Provisioner
        def provision
          server = nil

          handle_errors do
            server = connection.create_subnet(details['vpc_id'], details['cidr_block'])
          end

          # POPULATE PAYLOAD RESPONSE TEMPLATE
          payload_response = payload_response_template
          payload_response[:raw] = server

          # INCLUDE IP_ADDRESS IF PRESENT
          payload_response[:defaults][:ip_address] = server.local_address unless server.local_address.nil?

          @order_item.provision_status = :ok
          @order_item.payload_response = payload_response
        end

        def retire
          handle_errors do
            connection.delete_subnet(server_identifier)
          end
          @order_item.provision_status = :retired
        end

        private

        def connection
          ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)
        end

        def server_identifier
          @order_item.payload_response['raw']['data']['body']['subnet']['subnetId']
        end
      end
    end
  end
end
