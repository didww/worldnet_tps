require 'net/http'
require 'net/https'
require 'uri'
require_relative '../response/success'
require_relative '../response/error'
require_relative '../response/invalid_hash'
require_relative '../xsd'

module WorldnetTps
  module Request
    class Base

      class InvalidHashError < StandardError
      end

      class_attribute :invoke_method, :response_keys, instance_writer: false
      class_attribute :xsd_validation
      self.xsd_validation = true
      attr_reader :gateway, :request, :response, :attributes

      def initialize(gateway, attrs = {})
        @gateway = gateway
        @attributes = attrs.merge(
          currency: gateway.currency,
          date_time: self.class.current_date_time,
          terminal_id: gateway.terminal_id,
          shared_secret: gateway.shared_secret,
        )
      end

      def process!(struct)
        xml = build_xml(struct)
        validate_xml!(xml) if xsd_validation?
        uri = URI.parse(ws_url)
        http = Net::HTTP.new(uri.host, 443)
        http.use_ssl = true
        @request = Net::HTTP::Post.new(uri.request_uri)
        @request.body = xml
        @response = http.request(@request)
        build_response(@response)
      end

      def invoke!
        _invoke! invoke_method
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

      def validate_xml!(xml)
        WorldnetTps::XSD.validate!(xml)
      end

      def build_xml(struct)
        root = struct.keys.first
        data = Hash[struct[root].map { |k, v| [prepare_key(k), v.to_s] }]
        data.to_xml(root: prepare_key(root))
      end

      def build_failed_response(code, message)
        Response::Error.new(code, message)
      end

      def build_success_response(attributes)
        Response::Success.new(attributes)
      end

      def build_response(http_response)
        data = Hash.from_xml(http_response.body).values.first
        if data.keys[0] =~ /error/i
          build_failed_response(data['ERRORCODE'], data['ERRORSTRING'])
        else
          response_attributes = normalize_response_attributes(data)
          begin
            validate_hash!(response_attributes)
          rescue WorldnetTps::WsObject::InvalidHashError => e
            return Response::InvalidHash.new(response_attributes)
          end
          build_success_response(response_attributes)
        end
      end

      def _invoke!(action)
        add_check_sum!
        verify_request_keys!(self.class.mandatory_attributes(self), self.attributes)
        attrs = (request_attributes).inject({}) do |h, i|
          h[i] = self.attributes[i]
          h
        end.reject { |_, v| v.nil? }
        process!(action => attrs)
      end

      def request_attributes
        self.class.mandatory_attributes(self) + self.class.optional_attributes(self)
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

      def ws_url
        gateway.ws_url
      end

      def self.mandatory_attributes(_context)
        []
      end

      def self.optional_attributes(_context)
        []
      end

      def self.response_check_sum_keys(_context, _response)
        []
      end

      def self.request_check_sum_keys(_context)
        []
      end

    end
  end
end
