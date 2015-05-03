module PagSeguro
  class Session
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

      def id
        @id ||= response.data.css("session > id").text if success?
      end
    end
  end
end
