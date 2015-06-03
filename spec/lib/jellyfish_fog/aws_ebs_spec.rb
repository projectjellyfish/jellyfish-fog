module Jellyfish
  module Fog
    module AWS
      describe EBS do
        it 'creates a new ebs and then deletes it' do
          # INITIALIZE FOG IN MOCK MODE
          enable_aws_fog_provisioning

          # CREATE AN EBS
          ebs_order_item.answers = { 'size' => '5', 'availability_zone' => 'us-east-1a' }
          ebs = EBS.new(ebs_order_item).provision

          # CONVERT THE PAYLOAD_RESPONSE TO JSON SINCE IT IS PERSISTED THAT WAY IN ORDER ITEM
          ebs_order_item.payload_response = JSON.parse(ebs_order_item.payload_response.to_json)

          # VERIFY EBS WAS CREATED
          expect(ebs_order_item.provision_status).to eq :ok
          expect(ebs_order_item.payload_response['raw']['id']).to eq(ebs[:raw]['id'])

          # CREATE A FOG COMPUTE CONNECTION FOR RETIREMENT VERIFICATION
          connection = ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)
          expect(connection.volumes.count).to eq 1

          # RETIRE SUBNET
          ebs = EBS.new(ebs_order_item).retire
          sleep 1

          # VERIFY EBS WAS RETIRED
          expect(ebs).to eq(:retired)
          expect(connection.volumes.count).to eq 0
        end

        def ebs_order_item
          @ebs_order_item ||= OpenStruct.new
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
