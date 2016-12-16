module WorldnetTps
  module Response
    class Error

      attr_reader :code, :message

      def initialize(code, message)
        @code = code
        @message = message
      end

      def success?
        false
      end
    end
  end
end  
  