require 'nokogiri'
module WorldnetTps
  class XSD
    class Error < StandardError
      ##<Nokogiri::XML::SyntaxError: Element 'REFUND': Missing child element(s). Expected is ( DATETIME ).>
      attr_reader :internal_error
      def initialize(error)
        @internal_error = error
        super(error.to_s)
      end
    end

    SCHEMA_PATH =  File.join(File.dirname(__FILE__),'gateway.xsd')

    class << self
      def validate!(xml)
        document = Nokogiri::XML(xml)
        error = schema.validate(document).first
        raise Error.new(error) if error
      end

      def schema
        @schema ||= Nokogiri::XML::Schema(File.read(SCHEMA_PATH))
      end
    end
  end
end