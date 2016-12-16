module WorldnetTps
  module Request
    class Refund < WorldnetTps::Request::Base

      self.invoke_method = :refund

      self.response_keys = [
        :response_code,
        :response_text,
        :order_id,
        :unique_ref,
        :date_time,
        :hash,
        :processing_terminal
      ]

      def unique_key
        self[:unique_ref].present? ? :unique_ref : :order_id
      end

      def self.request_check_sum_keys(context)
        [
          :terminal_id,
          context.unique_key,
          :amount,
          :date_time,
          :response_code,
          :response_text,
          :shared_secret
        ]
      end

      def self.response_check_sum_keys(context, _response)
        [
          :terminal_id,
          context.unique_key,
          :amount,
          :date_time,
          :response_code,
          :response_text,
          :shared_secret
        ]
      end

      def self.mandatory_attributes(context)
        [
          context.unique_key,
          :terminal_id,
          :amount,
          :date_time,
          :hash,
          :operator,
          :reason
        ]
      end

    end
  end
end
