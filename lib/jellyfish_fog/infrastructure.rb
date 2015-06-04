module Jellyfish
  module Fog
    module VMWare
      class Infrastructure < Jellyfish::Provisioner
        def provision
          server = nil

          handle_errors do
            server = connection.vm_clone(details)
          end

          server['new_vm'] = server['new_vm'].except('parent')
          @order_item.provision_status = :ok
          @order_item.payload_response = server.to_json
        end

        private

        def connection
          ::Fog::Compute.new(Jellyfish::Fog::VMWare.settings)
        end
      end
    end

    module AWS
      class Infrastructure < Jellyfish::Provisioner
        def provision
          server = nil

          handle_errors do
            details['vpc_id'] = nil if details['vpc_id'].blank?
            details['subnet_id'] = nil if details['subnet_id'].blank?
            details['security_group_ids'] = nil if details['security_group_ids'].blank?
            server = connection.servers.create(details).tap { |s| s.wait_for { ready? } }
          end

          # POPULATE PAYLOAD RESPONSE TEMPLATE
          payload_response = payload_response_template
          payload_response[:raw] = JSON.parse(server.to_json)

          # INCLUDE IPADDRESS IF PRESENT
          payload_response[:defaults][:ip_address] = server.public_ip_address unless server.public_ip_address.nil?

          @order_item.provision_status = :ok
          @order_item.payload_response = payload_response
        end

        def retire
          handle_errors do
            connection.servers.get(server_identifier).destroy
          end
          @order_item.provision_status = :retired
        end

        private

        def connection
          ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)
        end

        def server_identifier
          @order_item.payload_response['raw']['id']
        end
      end
    end

    module Azure
      class Infrastructure < Jellyfish::Provisioner
        def provision
          server = nil
          current_vm = nil

          handle_errors do
            # CREATE THE AZURE VM CLONE
            server = connection.servers.create(details)

            # LOOK UP VMS ASSOCIATED WITH AZURE SUBSCRIPTION
            azure_vmms = ::Azure::VirtualMachineManagementService.new
            vms = azure_vmms.list_virtual_machines

            # LOCATE THE VM JUST CREATED
            # vms.each { |vm| current_vm = vm if vm.vm_name == details['vm_name'] }
            vms.each do |vm|
              current_vm = vm if vm.vm_name == details[:vm_name]
            end
          end

          # POPULATE PAYLOAD RESPONSE TEMPLATE
          payload_response = payload_response_template
          payload_response[:raw] = server.attributes

          # INCLUDE IPADDRESS AND HOSTANME IF THEY EXIST
          payload_response[:defaults][:ip_address] = current_vm.ipaddress unless current_vm.ipaddress.nil?
          payload_response[:defaults][:hostname] = current_vm.hostname unless current_vm.hostname.nil?

          # UPDATE ORDER ITEM - SET STATUS TO CRITICAL IF CANNOT LOCATE IPADDRESS
          @order_item.provision_status = current_vm.ipaddress.nil? ? :warning : :ok
          @order_item.payload_response = payload_response
        end

        def retire
          handle_errors do
            connection.delete_virtual_machine(server_attributes['vm_name'], server_attributes['cloud_service_name'])
          end
          @order_item.provision_status = :retired
        end

        private

        def connection
          ::Fog::Compute.new(Jellyfish::Fog::Azure.settings)
        end

        def server_attributes
          @order_item.payload_response['raw']
        end
      end
    end
  end
end
