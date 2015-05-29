module Jellyfish
  module Fog
    module VMWare
      describe Infrastructure do
        let(:vmware_server) do
          double('server_response',
                 response: { 'new_vm' => { 'id' => '50186187-12e0-5c4a-67bd-ce1b670a8f5d', 'name' => 'RHEL6_TEST_CLONE', 'uuid' => '4218c19a-7c5e-238f-1cea-fb2ffc3349dd' } })
        end
        let(:order_item) do
          double('order item',
                 id: 1, answers: { 'instance_uuid' => '42189f8b-b8d9-3a77-36c1-19f41f749e4f',
                                   'name' => 'CloneTestRHEL6',
                                   'datacenter' => 'RSP',
                                   'template_path' => 'RSP/TestRHEL6' })
        end

        it 'gets a connection' do
          run_in_mock_mode
          expect(Infrastructure.new(order_item).send(:connection)).to be_a_kind_of(::Fog::Compute::Vsphere::Mock)
        end

        it 'clones vmware infrastructure using fog' do
          run_in_mock_mode

          allow(order_item).to receive_message_chain(:provision_status=).with(:ok)
          allow(order_item).to receive_message_chain(:payload_response=).with(vmware_server.response.to_json)

          new_vm_spec = Infrastructure.new(order_item)

          # WE CAN'T CONNECT TO VSPHERE IN TEST, SO STUB THESE CHAINS FOR VM CLONE
          allow(new_vm_spec).to receive_message_chain('connection.vm_clone.get_virtual_machine') { true }
          allow(new_vm_spec).to receive_message_chain('connection.vm_clone.get_datacenter') { true }
          allow(new_vm_spec).to receive_message_chain('connection.vm_clone') { vmware_server.response }

          expect(new_vm_spec.provision).to eq(vmware_server.response.to_json)
        end

        def run_in_mock_mode
          ::Fog.mock!
          allow(ENV).to receive(:fetch).with('JELLYFISH_VMWARE_USERNAME').and_return('text')
          allow(ENV).to receive(:fetch).with('JELLYFISH_VMWARE_PASSWORD').and_return('text')
          allow(ENV).to receive(:fetch).with('JELLYFISH_VMWARE_SERVER').and_return('text')
          allow(ENV).to receive(:fetch).with('JELLYFISH_AWS_SECRET_ACCESS_KEY').and_return('text')
          allow(ENV).to receive(:fetch).with('JELLYFISH_VMWARE_EXPECTED_PUBKEY_HASH').and_return('text')
        end
      end
    end
  end
end
