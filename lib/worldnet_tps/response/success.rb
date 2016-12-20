module WorldnetTps
  module Response
    class Success < WorldnetTps::Response::Base
      def success?
        true
      end
    end
  end
end
