module WorldnetTps
  module Response
    class Error < WorldnetTps::Response::Base

      attr_reader :code, :message, :request

      def initialize(request, code, message)
        @code = code
        @message = message
        super(request)
      end

      def success?
        false
      end
    end
  end
end  
  