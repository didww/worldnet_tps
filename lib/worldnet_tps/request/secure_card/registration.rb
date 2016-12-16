require_relative '../base'
module WorldnetTps
  module Request
    module SecureCard
      # Used for processing XML SecureCard Registrations
      # through the WorldNet TPS XML Gateway.
      class Registration < WorldnetTps::Request::Base

        self.invoke_method = :secure_card_registration
        self.response_keys = [
          :merchant_ref,
          :card_reference,
          :date_time,
          :hash
        ]

        def self.response_check_sum_keys(_context, _response)
          [
            :terminal_id,
            :merchant_ref,
            :card_reference,
            :date_time,
            :shared_secret
          ]
        end

        def self.request_check_sum_keys(_context)
          [
            :terminal_id,
            :merchant_ref,
            :date_time,
            :card_number,
            :card_expiry,
            :card_type,
            :card_holder_name,
            :shared_secret
          ]
        end

        def self.optional_attributes(_context)
          [
            :dont_check_security,
            :cvv,
            :ussue_no
          ]
        end

        alias :create! :invoke!
        #alias_method :invoke!, :create!

        def update!
          _invoke! :secure_card_update
        end

        def self.mandatory_attributes(_context)
          [
            :merchant_ref,
            :terminal_id,
            :date_time,
            :card_number,
            :card_expiry,
            :card_type,
            :card_holder_name,
            :hash
          ]
        end

      end
    end
  end
end