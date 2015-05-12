module Jellyfish
  module Fog
    class Storage < Jellyfish::Provisioner
      def provision
        instance_name = "id-#{order_item.uuid[0..9]}"
        begin
          storage = connection.directories.create(key: instance_name, public: true)
        rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
          raise e, 'Bad request. Check for valid credentials and proper permissions.', e.backtrace
        end

        order_item.payload_response = storage.to_json
        order_item.provision_status = 'ok'
      end

      def retire
        connection.delete_bucket(storage_key)
        order_item.provision_status = 'retired'
      rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
        raise e, 'Bad request. Check for valid credentials and proper permissions.', e.backtrace
      end

      private

      def connection
        ::Fog::Storage.new(Jellyfish::Fog.aws_settings.merge(provider: 'AWS'))
      end

      def storage_key
        order_item.payload_response['key']
      end
    end
  end
end
