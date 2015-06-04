module Jellyfish
  module Fog
    module AWS
      class Storage < Jellyfish::Provisioner
        def provision
          storage = nil

          handle_errors do
            storage_name = "id-#{order_item.uuid[0..9]}"
            storage = connection.directories.create(key: storage_name)
          end

          # POPULATE PAYLOAD RESPONSE TEMPLATE
          payload_response = payload_response_template
          payload_response[:raw] = storage

          @order_item.provision_status = :ok
          @order_item.payload_response = payload_response
        end

        def retire
          handle_errors do
            connection.delete_bucket(identifier)
          end
          order_item.provision_status = :retired
        end

        private

        def connection
          ::Fog::Storage.new(Jellyfish::Fog::AWS.settings)
        end

        def identifier
          @order_item.payload_response['raw']['key']
        end
      end
    end
  end
end
