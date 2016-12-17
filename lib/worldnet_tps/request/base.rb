require 'net/http'
require 'net/https'
require 'uri'
require_relative '../response/success'
require_relative '../response/error'
require_relative '../response/invalid_hash'
require_relative '../xsd'

module WorldnetTps
  module Request
    class Base < WorldnetTps::WsObject

      class_attribute :invoke_method, :response_keys, instance_writer: false
      attr_reader :gateway, :request, :response, :date_time, :attributes

      class_attribute :xsd_validation
      self.xsd_validation = true

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

      protected

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

      def ws_url
        gateway.ws_url
      end
    end
  end
end
