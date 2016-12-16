module WorldnetTps
  module Request
    module SecureCard
      class Search < WorldnetTps::Request::Base

        def initialize(gateway, merchant_ref)
          super(gateway, { merchant_ref: merchant_ref })
        end

        self.invoke_method = :secure_card_search

        self.response_keys = [:merchant_ref, :card_reference, :card_type,
                              :card_expiry, :card_holder_name, :date_time, :hash]

        def self.request_check_sum_keys(_context)
          [
            :terminal_id,
            :merchant_ref,
            :date_time,
            :shared_secret
          ]
        end

        def self.response_check_sum_keys(_context, _response)
          [
            :terminal_id,
            :merchant_ref,
            :card_reference,
            :card_type,
            :card_expiry,
            :card_holder_name,
            :date_time,
            :shared_secret
          ]
        end



        def self.mandatory_attributes(_context)
          [
            :merchant_ref,
            :terminal_id,
            :date_time,
            :hash
          ]
        end


      end
    end
  end
end