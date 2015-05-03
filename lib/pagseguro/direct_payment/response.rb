module PagSeguro
  class DirectPayment
    class Response
      extend Forwardable

      def_delegators :response, :success?
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def errors
        @errors ||= Errors.new(response)
      end

      def method
        if success?
          method = PaymentMethod.new
          method.type_id = response.data.css("transaction > paymentMethod > type").text.to_i
          return method
        end
      end

      def status
        PaymentStatus.new(response.data.css("transaction > status").text.to_i).status if success?
      end

      def payment_link
        response.data.css("transaction > paymentLink").text if success?
      end

      def code
        @code ||= response.data.css("checkout > code").text if success?
      end

      def created_at
        @created_at ||= Time.parse(response.data.css("checkout > date").text) if success?
      end
    end
  end
end
