module WorldnetTps
  module Request
    #@see: https://docs.worldnettps.com/doku.php?id=developer:integrator_guide:5._xml_integration:5.1._request_types:5.1.1._xml_payments
    class Payment < WorldnetTps::Request::Base

      self.invoke_method = :payment

      def self.response_check_sum_keys(_context, response)
        unique_key =  response[:unique_ref].present? ? :unique_ref : :order_id
        [
          :terminal_id,
          unique_key,
          :amount,
          :date_time,
          :response_code,
          :response_text,
          :shared_secret
        ]
      end


      def self.request_check_sum_keys(_context)
        [
          :terminal_id,
          :order_id,
          :amount,
          :date_time,
          :shared_secret
        ]
      end

      self.response_keys = [:unique_ref, :response_code, :response_text, :approval_code, :date_time, :avs_response, :cvv_response, :hash]

      def initialize(gateway, attrs)
        super
        #by default TERM_INTERNET = 2 # eCommerce
        assign(:terminal_type, WorldnetTps::Const::TERM_INTERNET) if attributes[:terminal_type].blank?
        #by default TRANS_INTERNET = 7 #eCommerce
        assign(:transaction_type, WorldnetTps::Const::TRANS_INTERNET) if attributes[:transaction_type].blank?
      end

      def secured_card?
        WorldnetTps::Const::SECURECARD == self[:card_type]
      end


      def self.mandatory_attributes(context)
        keys = [
          :order_id,
          :terminal_id,
          :amount,
          :date_time,
          :card_number,
          :card_type
        ]

        keys += [:card_expiry, :card_holder_name] unless context.secured_card?
        keys += [:hash, :currency, :terminal_type, :transaction_type]
        keys
      end

      def self.optional_attributes(_context)
        [
          :auto_ready,
          :email,
          :cvv,
          :issue_no,
          :address1,
          :address2,
          :post_code,
          :avs_only,
          :description,
          :xid,
          :cavv,
          :mpiref,
          :mobile_number,
          :device_id,
          :phone,
          :city,
          :region,
          :country,
          :ip_address,
          :signature
        ]
      end
    end
  end

end