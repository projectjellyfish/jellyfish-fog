module Jellyfish
  module Fog
    module AWS
      describe SecurityGroup do
        it 'creates a new security group and then deletes it' do
          # INITIALIZE FOG IN MOCK MODE
          enable_aws_fog_provisioning

          # CREATE A FOG COMPUTE CONNECTION
          connection = ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)

          # CREATE A VPC
          security_group_order_item.answers = { 'name' => 'jellyfish', 'description' => 'jellyfish users', 'vpc_id' => '' }
          SecurityGroup.new(security_group_order_item).provision
          expect(security_group_order_item.provision_status).to eq :ok
          expect(security_group_order_item.payload_response[:raw][:body]['groupId']).to eq(connection.security_groups.find { |i| i.name == security_group_order_item.answers['name'] }.group_id)

          # CONVERT THE PAYLOAD_RESPONSE TO JSON SINCE IT IS PERSISTED THAT WAY IN ORDER ITEM
          security_group_order_item.payload_response = JSON.parse(security_group_order_item.payload_response.to_json)

          # RETIRE SECURITY GROUP
          SecurityGroup.new(security_group_order_item).retire
          expect(connection.security_groups.count { |i| i.name == security_group_order_item.answers['name'] }).to eq 0
        end

        def security_group_order_item
          @vpc_order_item ||= OpenStruct.new
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
