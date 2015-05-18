module Jellyfish
  module Fog
    module AWS
      describe Databases do
        it 'provisions and retires databases using fog' do
          enable_aws_fog_provisioning

          Databases.new(order_item).provision

          expect(order_item.provision_status).to eq 'ok'
          order_item.payload_response = JSON.parse(order_item.payload_response)
          expect(
            order_item.payload_response['data']['body']['CreateDBInstanceResult']['DBInstance']
          ).to include(
            order_item.answers.merge('DBInstanceIdentifier' => "id-#{order_item.uuid}")
          )

          Databases.new(order_item).retire

          expect(order_item.provision_status).to eq 'retired'
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
