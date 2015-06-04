module Jellyfish
  module Fog
    module AWS
      class SecurityGroup < Jellyfish::Provisioner
        def provision
          server = nil

          handle_errors do
            # create_security_group(name, description, vpc_id = nil)
            details['vpc_id'] = nil if details['vpc_id'].blank?
            server = connection.create_security_group(details['name'], details['description'], details['vpc_id'])
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
            security_group_name = nil
            connection.delete_security_group(security_group_name, server_identifier)
          end
          @order_item.provision_status = :retired
        end

        private

        def connection
          ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)
        end

        def server_identifier
          @order_item.payload_response['raw']['data']['body']['groupId']
        end
      end
    end
  end
end
