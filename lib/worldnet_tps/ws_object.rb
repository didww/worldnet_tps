module WorldnetTps
  class WsObject

    attr_reader :gateway, :request, :response, :date_time, :attributes

    class InvalidHashError < StandardError

    end

    def initialize(gateway, attrs = {})
      @gateway = gateway
      @attributes = attrs.merge(
          currency: gateway.currency,
          date_time: self.class.current_date_time,
          terminal_id: gateway.terminal_id,
          shared_secret: gateway.shared_secret,

      )
    end

    def self.current_date_time
      DateTime.now.utc.strftime('%d-%m-%Y:%H:%M:%S:000')
    end

    protected

    def []=(name, value)
      @attributes[name] = value
    end

    alias :assign :[]=

    def [](name)
      @attributes[name]
    end

    def normalize_response_attributes(source)
      response_keys.inject(Hash.new) do |hash, el|
        hash[el] = source[prepare_key(el)]
        hash
      end
    end

    def validate_hash!(response_attrs)
      #check hash
      response_source = self.class.response_check_sum_keys(self, response_attrs).inject("") do |str, el|
        str << (response_attrs[el] || @attributes[el]).to_s
        str
      end
      response_hash = Digest::MD5.hexdigest(response_source)
      raise InvalidHashError.new "invalid HASH value" if response_attrs[:hash] != response_hash
    end


    def verify_request_keys!(required_keys, attributes)
      invalid_keys = required_keys - attributes.keys
      if invalid_keys.any?
        keys = invalid_keys.sort_by { |k| k.to_s }.join(", ")
        raise ArgumentError, "#{keys} arguments are mandatory"
      end
    end

    def request_hash
      Digest::MD5.hexdigest self.class.request_check_sum_keys(self).inject("") { |str, el| str << attributes[el].to_s; str }
    end

    def add_check_sum!
      @attributes[:hash] = request_hash
    end

    def prepare_key(k)
      k.to_s.upcase.gsub("_", "")
    end

  end
end