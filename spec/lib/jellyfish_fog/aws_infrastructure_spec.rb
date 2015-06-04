module Jellyfish
  module Fog
    module AWS
      describe Infrastructure do
        it 'provisions and deletes infrastructure using fog' do
          # INITIALIZE FOG IN MOCK MODE
          enable_aws_fog_provisioning

          # CREATE AN EC2 INSTANCE
          order_item.answers = { 'image_id' => 'ami-1ccae774' }
          server = Infrastructure.new(order_item).provision

          # CONVERT THE PAYLOAD_RESPONSE TO JSON SINCE IT IS PERSISTED THAT WAY IN ORDER ITEM
          order_item.payload_response = JSON.parse(order_item.payload_response.to_json)

          # VERIFY THAT INSTANCE WAS CREATED
          expect(order_item.provision_status).to eq :ok
          expect(order_item.payload_response['raw']).to have_key('id')
          expect(order_item.payload_response['raw']['image_id']).to eq('ami-1ccae774')

          # CREATE A FOG COMPUTE CONNECTION FOR RETIREMENT VERIFICATION
          connection = ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)
          expect(connection.servers.count).to eq 1

          # DELETE EC2 INSTANCE
          server = Infrastructure.new(order_item).retire

          # VERIFY EC2 INSTANCE WAS DELETED (SLEEP B/C MOCK FOG NEEDS TIME TO REMOVE INSTANCE FROM MEMORY)
          expect(order_item.provision_status).to eq :retired
          sleep 2
          expect(connection.servers.count).to eq 0
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
