module Jellyfish
  module Fog
    module AWS
      class VPC < Jellyfish::Provisioner
        def provision
          server = nil

          handle_errors do
            server = connection.create_vpc(details['cidr_block'])
          end

          # POPULATE PAYLOAD RESPONSE TEMPLATE
          payload_response = payload_response_template
          payload_response[:raw] = server

          # INCLUDE IPADDRESS IF PRESENT
          payload_response[:defaults][:ip_address] = server.local_address unless server.local_address.nil?

          @order_item.provision_status = :ok
          @order_item.payload_response = payload_response
        end

        def retire
          handle_errors do
            connection.delete_vpc(server_identifier)
          end
          @order_item.provision_status = :retired
        end

        private

        def connection
          ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)
        end

        def server_identifier
          @order_item.payload_response['raw']['data']['body']['vpcSet'][0]['vpcId']
        end
      end
    end
  end
end
