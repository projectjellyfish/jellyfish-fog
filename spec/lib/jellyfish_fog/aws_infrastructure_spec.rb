module Jellyfish
  module Fog
    module AWS
      describe Infrastructure do
        it 'provisions and retires infrastructure using fog' do
          enable_aws_fog_provisioning

          order_item.answers = { 'image_id' => 'ami-1ccae774' }
          Infrastructure.new(order_item).provision

          expect(order_item.provision_status).to eq :ok
          order_item.payload_response = JSON.parse(order_item.payload_response)
          expect(order_item.payload_response).to have_key('id')
          expect(order_item.payload_response['image_id']).to eq('ami-1ccae774')

          Infrastructure.new(order_item).retire

          expect(order_item.provision_status).to eq :retired
        end

        def order_item
          @order_item ||= OpenStruct.new
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
