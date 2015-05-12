require 'bcrypt'

module Jellyfish
  module Fog
    class Databases < Jellyfish::Provisioner
      def provision
        @password = SecureRandom.hex(5)
        db_instance_id = "id-#{@order_item.uuid[0..9]}"
        handle_errors do
          db = connection.create_db_instance(db_instance_id, details)
          @order_item.payload_response = db.to_json
          @order_item.provision_status = 'ok'
        end
      end

      def retire
        connection.delete_db_instance(identifier, snapshot, false)
        @order_item.provision_status = 'retired'
      rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
        raise e, 'Bad request. Check for valid credentials and proper permissions.', e.backtrace
      end

      private

      def details
        @order_item.answers.merge(
          'MasterUserPassword' => @password,
          'MasterUsername' => 'admin'
        )
      end

      def connection
        ::Fog::AWS::RDS.new(Jellyfish::Fog::AWS.aws_settings)
      end

      def identifier
        @order_item.payload_response['data']['body']['CreateDBInstanceResult']['DBInstance']['DBInstanceIdentifier']
      end

      def snapshot
        "snapshot-#{@order_item.uuid[0..5]}"
      end

      def handle_errors
        yield
      rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
        raise e, 'Bad request. Check for valid credentials and proper permissions.', e.backtrace
      end
    end
  end
end
