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
          @order_item.provision_status = 'ok'
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
            server = connection.servers.create(details).tap { |s| s.wait_for { ready? } }
          end

          @order_item.provision_status = 'ok'
          @order_item.payload_response = server.to_json
        end

        def retire
          handle_errors do
            connection.servers.delete(server_identifier)
          end
          @order_item.provision_status = 'retired'
        end

        private

        def connection
          ::Fog::Compute.new(Jellyfish::Fog::AWS.settings)
        end

        def server_identifier
          @order_item.payload_response['id']
        end
      end
    end

    module Azure
      class Infrastructure < Jellyfish::Provisioner
        def provision
          server = nil

          handle_errors do
            server = connection.servers.create(details)
          end

          order_item.provision_status = :ok
          order_item.payload_response = server.attributes
        end

        def retire
          handle_errors do
            connection.delete_virtual_machine(server_attributes[:vm_name], server_attributes[:cloud_service_name])
          end
          order_item.provision_status = :retired
        end

        private

        def connection
          ::Fog::Compute.new(Jellyfish::Fog::Azure.settings)
        end

        def server_attributes
          order_item.payload_response
        end
      end
    end
  end
end
