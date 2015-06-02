module Jellyfish
  module Fog
    module AWS
      describe VPC do
        it 'creates a new vpc' do
          enable_aws_fog_provisioning
          order_item.answers = { 'cidr_block' => '10.0.0.0/16' }
          server = VPC.new(order_item).provision
          expect(order_item.provision_status).to eq :ok
          expect(order_item.payload_response[:raw][:body]['vpcSet'][0]['cidrBlock']).to eq('10.0.0.0/16')
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
