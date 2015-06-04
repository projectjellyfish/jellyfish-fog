require 'bcrypt'

module Jellyfish
  module Fog
    module AWS
      class Database < Jellyfish::Provisioner
        def provision
          db = nil
          handle_errors do
            # GENERATE PASSWORD AND INSTANCE ID
            @password = SecureRandom.hex(5)
            db_instance_id = "id-#{@order_item.uuid[0..9]}"

            # CREATE DB INSTANCE
            db = connection.create_db_instance(db_instance_id, details)

            # POPULATE PAYLOAD RESPONSE TEMPLATE
            payload_response = payload_response_template
            payload_response[:raw] = db

            # INCLUDE IPADDRESS IF PRESENT
            payload_response[:defaults][:ip_address] = db.local_address unless db.local_address.nil?

            @order_item.provision_status = :ok
            @order_item.payload_response = payload_response
          end
        end

        def retire(skip_final_snap_shot = true)
          handle_errors do
            snapshot_id = skip_final_snap_shot ? '': snapshot
            connection.delete_db_instance(identifier, snapshot_id, skip_final_snap_shot)
          end
          @order_item.provision_status = :retired
        end

        private

        def details
          @order_item.answers.merge(
            'MasterUserPassword' => @password,
            'MasterUsername' => 'admin'
          )
        end

        def connection
          ::Fog::AWS::RDS.new(Jellyfish::Fog::AWS.settings.except(:provider))
        end

        def identifier
          @order_item.payload_response['raw']['data']['body']['CreateDBInstanceResult']['DBInstance']['DBInstanceIdentifier']
        end

        def snapshot
          "snapshot-#{@order_item.uuid[0..5]}"
        end
      end
    end
  end
end
