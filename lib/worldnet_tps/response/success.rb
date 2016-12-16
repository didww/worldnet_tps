module WorldnetTps
  module Response
    class Success

      attr_reader :attributes

      def initialize(attributes = {}) # :nodoc:
        @attributes = attributes

        singleton_class.class_eval do
          attributes.each do |key, value|
            define_method key do
              value
            end
          end
        end
      end

      def success?
        true
      end

    end
  end
end
