module Jellyfish
  module Fog
    module AWS
      describe Storage do
        it 'provisions and deletes s3 bucket using fog' do
          # INITIALIZE FOG IN MOCK MODE
          enable_aws_fog_provisioning

          # CREATE AN S3 BUCKET
          Storage.new(order_item).provision

          # CONVERT THE PAYLOAD_RESPONSE TO JSON SINCE IT IS PERSISTED THAT WAY IN ORDER ITEM
          tmp = order_item.payload_response[:raw]
          order_item.payload_response[:raw] = {}
          order_item.payload_response[:raw][:key] = tmp.key
          order_item.payload_response[:raw][:creation_date] = tmp.creation_date
          order_item.payload_response[:raw][:location] = tmp.location
          order_item.payload_response = JSON.parse(order_item.payload_response.to_json)

          # CREATE A FOG COMPUTE CONNECTION FOR VERIFICATION
          connection = ::Fog::Storage.new(Jellyfish::Fog::AWS.settings)

          # VERIFY THAT BUCKET WAS CREATED
          expect(order_item.provision_status).to eq :ok
          expect(connection.directories.count).to eq 1
          expect(connection.directories.any? { |bucket| bucket.key == "id-#{order_item.uuid}" }).to eq true

          # DELETE AN S3 BUCKET
          Storage.new(order_item).retire
          expect(order_item.provision_status).to eq :retired
          expect(connection.directories.count).to eq 0
        end

        def order_item
          @order_item ||= OpenStruct.new.tap do |order_item|
            order_item.uuid = '1234567890'
          end
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
