module Jellyfish
  module Fog
    module AWS
      describe Database do
        it 'provisions and deletes database using fog' do
          # INITIALIZE FOG IN MOCK MODE
          enable_aws_fog_provisioning

          # CREATE AN DATABASE INSTANCE
          db = Database.new(order_item).provision

          # CONVERT THE PAYLOAD_RESPONSE TO JSON SINCE IT IS PERSISTED THAT WAY IN ORDER ITEM
          order_item.payload_response = JSON.parse(order_item.payload_response.to_json)

          # VERIFY THAT INSTANCE WAS CREATED
          expect(order_item.provision_status).to eq :ok
          expect(
            order_item.payload_response['raw']['data']['body']['CreateDBInstanceResult']['DBInstance']
          ).to include(
            order_item.answers.merge('DBInstanceIdentifier' => "id-#{order_item.uuid}")
          )

          # CREATE A FOG COMPUTE CONNECTION FOR RETIREMENT VERIFICATION
          connection = ::Fog::AWS::RDS.new(Jellyfish::Fog::AWS.settings.except(:provider))
          expect(connection.servers.count).to eq 1

          # DELETE DATABASE INSTANCE
          db = Database.new(order_item).retire

          # VERIFY EC2 INSTANCE WAS DELETED
          expect(order_item.provision_status).to eq :retired
          expect(connection.servers.count).to eq 0
        end

        def order_item
          @order_item ||= OpenStruct.new.tap do |order_item|
            order_item.uuid = '1234567890'
            order_item.answers = {
              'AllocatedStorage' => 100,
              'DBInstanceClass' => 'Test',
              'Engine' => 'Test'
            }
          end
        end

        def enable_aws_fog_provisioning
          ::Fog.mock!
          allow(ENV).to receive(:fetch).with('JELLYFISH_AWS_ACCESS_KEY_ID').and_return('text')
          allow(ENV).to receive(:fetch).with('JELLYFISH_AWS_SECRET_ACCESS_KEY').and_return('text')
        end
      end
    end
  end
end
