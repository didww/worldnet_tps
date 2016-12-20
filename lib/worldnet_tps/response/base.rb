module WorldnetTps
  module Response
    class Base
      attr_reader :request, :attributes
      def initialize(request, attributes = {})
        @request = request
        @attributes = attributes
        singleton_class.class_eval do
          attributes.each do |key, value|
            define_method key do
              value
            end
          end
        end
      end

    end
  end
end