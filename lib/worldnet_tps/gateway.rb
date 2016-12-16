require_relative 'request/secure_card/registration'
require_relative 'request/secure_card/removal'
require_relative 'request/secure_card/search'
require_relative 'request/payment'
require_relative 'request/refund'

module WorldnetTps
  class Gateway

    attr_reader :gateway, :environment, :terminal_id, :shared_secret, :currency

    PRODUCTION_ENVS = [:production, :live]

    def initialize(attributes)
      @gateway = attributes.fetch(:gateway)
      @environment = attributes.fetch(:environment)
      @terminal_id = attributes.fetch(:terminal_id)
      @shared_secret = attributes.fetch(:shared_secret)
      @currency = attributes.fetch(:currency)
    end

    def is_test?
      !is_live?
    end

    def is_live?
      PRODUCTION_ENVS.include? self.environment
    end

    def secure_card_removal(merchant_ref, card_reference)
      Request::SecureCard::Removal.new(self, merchant_ref, card_reference)
    end

    def secure_card_search(merchant_ref)
      Request::SecureCard::Search.new(self, merchant_ref)
    end

    def secure_card_registration(attributes = {})
      Request::SecureCard::Registration.new(self, attributes)
    end

    def refund(attributes = {})
      Request::Refund.new(self, attributes)
    end

    def payment(attributes = {})
      Request::Payment.new(self, attributes)
    end

    def endpoint
      @endpoint ||= begin
        domain = case gateway.to_s.downcase
          when 'cashflows'
            'cashflows.worldnettps.com'
          else
            'payments.worldnettps.com'
        end
        domain = "test#{domain}" if is_test?
        "https://#{domain}"
      end
    end

    #
    #todo: validate agains xsd
    #
    def ws_url
      "#{self.endpoint}/merchant/xmlpayment"
    end

  end
end
