module Jellyfish
  module Fog
    module AWS
      describe Storage do
        it 'provisions and retires storage using fog' do
          enable_aws_fog_provisioning

          Storage.new(order_item).provision

          expect(order_item.provision_status).to eq 'ok'
          order_item.payload_response = JSON.parse(order_item.payload_response)
          expect(order_item.payload_response).to include('key' => "id-#{order_item.uuid}")

          Storage.new(order_item).retire

          expect(order_item.provision_status).to eq 'retired'
        end

        def order_item
          @order_item ||= OpenStruct.new.tap do |order_item|
            order_item.uuid = '1234567890'
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
