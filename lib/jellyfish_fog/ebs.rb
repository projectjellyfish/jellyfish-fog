module Jellyfish
  module Fog
    module AWS
      class EBS < Jellyfish::Provisioner
        def provision
          server = nil

          handle_errors do
            server = connection.volumes.new(details)
            server.save
          end

          # POPULATE PAYLOAD RESPONSE TEMPLATE
          payload_response = payload_response_template
          payload_response[:raw] = JSON.parse(server.to_json)

          @order_item.provision_status = :ok
          @order_item.payload_response = payload_response
        end

        def retire
          handle_errors do
            connection.volumes.get(server_identifier).destroy
          end
          @order_item.provision_status = :retired
        end

        private

        def connection
          ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)
        end

        def server_identifier
          @order_item.payload_response['raw']['id']
        end
      end
    end
  end
end
