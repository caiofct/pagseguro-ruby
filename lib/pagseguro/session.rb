module PagSeguro
  class Session
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # The email that identifies the request. Defaults to PagSeguro.email
    attr_accessor :email

    # The token that identifies the request. Defaults to PagSeguro.token
    attr_accessor :token

    # Calls the PagSeguro web service and register this request for payment.
    def register
      params = Serializer.new(self).to_params.merge({
        email: email,
        token: token
      })
      Response.new Request.post("sessions", params)
    end

    private
    def before_initialize
      self.email    = PagSeguro.email
      self.token    = PagSeguro.token
    end

    def endpoint
      PagSeguro.api_url("sessions")
    end
  end
end
