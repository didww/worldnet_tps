module WorldnetTps
  module Request
    module SecureCard
      class Removal < WorldnetTps::Request::Base

        def initialize(gateway, merchant_ref, card_reference)
          super(gateway, {merchant_ref: merchant_ref, card_reference: card_reference})
        end

        self.invoke_method =  :secure_card_removal
        self.response_keys = [:merchant_ref, :date_time, :hash]

        def self.request_check_sum_keys(_context)
          [
            :terminal_id,
            :merchant_ref,
            :date_time,
            :card_reference,
            :shared_secret
          ]
        end

        def self.response_check_sum_keys(_context, _response)
          [
            :terminal_id,
            :merchant_ref,
            :date_time,
            :shared_secret
          ]
        end


        def self.mandatory_attributes(_context)
          [
            :merchant_ref,
            :card_reference,
            :terminal_id,
            :date_time,
            :hash
          ]
        end

      end
    end
  end
end