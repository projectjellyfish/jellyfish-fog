module Jellyfish
  module Fog
    module Azure
      describe Infrastructure do
        order_item_answers = { :image => 'a699494373c04fc0bc8f2bb1389d6106__Win2K8R2SP1-Datacenter-201504.01-en.us-127GB.vhd',
                               :location => 'West US',
                               :vm_name => 'fogvmclone',
                               :vm_user => 'jellyfish',
                               :password => 'ComplexPassword!123',
                               :storage_account_name => 'fogvmclonestorage'}

        let(:order_item) do
          double('order_item', id: 1, answers: order_item_answers )
        end

        let(:azure_server) do
          double('azure_server', response: { :defaults=>{:ip_address=>'127.0.0.1', :hostname=>'foo.bar.com', :total=>'0.0'}, :raw => order_item_answers.merge(:cloud_service_name => 'fogvmclone') } )
        end

        class FakeVM
          def vm_name
            'fogvmclone'
          end
          def ipaddress
            '127.0.0.1'
          end
          def hostname
            'foo.bar.com'
          end
        end

        it 'gets a connection' do
          run_in_mock_mode
          expect(Infrastructure.new(order_item).send(:connection)).to be_a_kind_of(::Fog::Compute::Azure::Mock)
        end

        it 'clones azure infrastructure using fog' do
          run_in_mock_mode

          fake_class = Class.new do
            def list_virtual_machines
              [ FakeVM.new ]
            end
          end
          stub_const("::Azure::VirtualMachineManagementService", fake_class)

          allow(order_item).to receive_message_chain(:provision_status=).with(:ok)
          allow(order_item).to receive_message_chain(:payload_response=).with(azure_server.response)

          new_vm_spec = Infrastructure.new(order_item)

          new_vm_spec.provision

        end

        def run_in_mock_mode
          ::Fog.mock!
          allow(ENV).to receive(:fetch).with('JELLYFISH_AZURE_SUB_ID').and_return('text')
          allow(ENV).to receive(:fetch).with('JELLYFISH_AZURE_PEM_PATH').and_return('text')
          allow(ENV).to receive(:fetch).with('JELLYFISH_AZURE_API_URL').and_return('text')
          # allow(ENV).to receive(:[]).with('JELLYFISH_AZURE_SUB_ID').and_return('text')
          # allow(ENV).to receive(:[]).with('JELLYFISH_AZURE_PEM_PATH').and_return('text')
          # allow(ENV).to receive(:[]).with('JELLYFISH_AZURE_API_URL').and_return('text')
        end
      end
    end
  end
end
