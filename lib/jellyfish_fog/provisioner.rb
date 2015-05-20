module Jellyfish
  class Provisioner
    attr_reader :order_item

    def self.provision(order_item_id)
      perform(order_item_id, :critical_error) { |order_item| new(order_item).provision }
    end

    def self.retire(order_item_id)
      perform(order_item_id, :warning_retirement_error) { |order_item| new(order_item).retire }
    end

    def initialize(order_item)
      @order_item = order_item
    end

    def details
      order_item.answers
    end

    def self.perform(order_item_id, error_method)
      order_item = OrderItem.find(order_item_id)
      yield order_item
    rescue => e
      send(error_method, order_item, e.message)
      raise
    ensure
      order_item.save!
    end

    def self.warning_retirement_error(order_item, message)
      order_item.provision_status = :warning
      order_item.status_msg = "Retirement failed: #{message}"[0..254]
    end

    def self.critical_error(order_item, message)
      order_item.provision_status = :critical
      order_item.status_msg = message
    end

    private

    def handle_errors
      yield
    rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
      raise e, 'Bad request. Check for valid credentials and proper permissions.', e.backtrace
    end
  end
end
