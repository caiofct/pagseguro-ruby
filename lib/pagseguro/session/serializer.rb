module PagSeguro
  class Session
    class Serializer
      attr_reader :session

      def to_params
        {}
      end

      def initialize(session)
        @session = session
      end
    end
  end
end
