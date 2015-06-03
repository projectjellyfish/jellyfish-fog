module Jellyfish
  module Fog
    module AWS
      describe Subnet do
        it 'creates a new subet and then deletes it' do
          # INITIALIZE FOG IN MOCK MODE
          enable_aws_fog_provisioning

          # CREATE A VPC
          vpc_cidr_block = '10.0.0.0/16'
          vpc_order_item.answers = { 'cidr_block' => vpc_cidr_block }
          server = VPC.new(vpc_order_item).provision
          expect(vpc_order_item.provision_status).to eq :ok
          expect(vpc_order_item.payload_response[:raw][:body]['vpcSet'][0]['cidrBlock']).to eq(vpc_cidr_block)

          # CREATE A SUBNET INSIDE OF THE ABOVE VPC
          subnet_cidr_block = '10.0.0.0/24'
          subnet_order_item.answers = { 'vpc_id' => vpc_order_item.payload_response[:raw][:body]['vpcSet'][0]['vpcId'], 'cidr_block' => subnet_cidr_block }
          subnet = Subnet.new(subnet_order_item).provision
          expect(subnet_order_item.provision_status).to eq :ok
          expect(subnet_order_item.payload_response[:raw][:body]['subnet']['vpcId']).to eq(subnet_order_item.answers['vpc_id'])
          expect(subnet_order_item.payload_response[:raw][:body]['subnet']['cidrBlock']).to eq(subnet_cidr_block)

          # CREATE A FOG COMPUTE CONNECTION FOR RETIREMENT VERIFICATION
          connection = ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)
          expect(connection.subnets.count).to eq 1

          # CONVERT THE PAYLOAD_RESPONSE TO JSON SINCE IT IS PERSISTED THAT WAY IN ORDER ITEM
          subnet_order_item.payload_response = JSON.parse(subnet_order_item.payload_response.to_json)

          # RETIRE SUBNET
          subnet = Subnet.new(subnet_order_item).retire
          expect(connection.subnets.count).to eq 0

          # CONVERT THE PAYLOAD_RESPONSE TO JSON SINCE IT IS PERSISTED THAT WAY IN ORDER ITEM
          vpc_order_item.payload_response = JSON.parse(vpc_order_item.payload_response.to_json)

          # RETIRE VPC
          vpc = VPC.new(vpc_order_item).retire
          expect(connection.vpcs.count).to eq 0
        end

        def vpc_order_item
          @vpc_order_item ||= OpenStruct.new
        end

        def subnet_order_item
          @subnet_order_item ||= OpenStruct.new
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
