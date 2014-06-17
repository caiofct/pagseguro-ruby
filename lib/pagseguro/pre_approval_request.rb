module PagSeguro
  class PreApprovalRequest
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set the redirect url.
    # The URL that will be used by PagSeguro to redirect the user after
    # the payment information is processed. Typically this is a
    # confirmation page on your web site.
    attr_accessor :redirect_url

    # Determines for which url PagSeguro will send the order related
    # notifications codes.
    # Optional. Any change happens in the transaction status, a new notification
    # request will be send to this url. You can use that for update the related
    # order.
    attr_accessor :notification_url

    # Set the review url.
    # The URL that will be user by PagSeguro to show the product's details
    # to the user.
    attr_accessor :review_url

    # Set the reference code.
    # Optional. You can use the reference code to store an identifier so you can
    # associate the PagSeguro transaction to a transaction in your system.
    # Tipically this is the order id.
    attr_accessor :reference

    # The email that identifies the request. Defaults to PagSeguro.email
    attr_accessor :email

    # The token that identifies the request. Defaults to PagSeguro.token
    attr_accessor :token

    # Get the payment sender.
    attr_reader :sender

    # Subscription pre-approval params.    
    attr_reader :pre_approval

    # Set the pre-approval sender.
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    # Set the pre-approval data.
    def pre_approval=(pre_approval)
      @pre_approval = ensure_type(PreApproval, pre_approval)
    end

    # Calls the PagSeguro web service and register this request for payment.
    def register
      params = Serializer.new(self).to_params.merge({
        email: email,
        token: token
      })
      Response.new Request.post("pre-approvals/request", params)
    end
      
    private
    def before_initialize
      self.email    = PagSeguro.email
      self.token    = PagSeguro.token
    end

    def endpoint
      PagSeguro.api_url("pre-approvals/request")
    end
  end
end