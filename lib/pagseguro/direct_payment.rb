module PagSeguro
  class DirectPayment
    include Extensions::MassAssignment
    include Extensions::EnsureType

    attr_accessor :redirect_url
    #Direct Payment Attributes

    # The payment mode.
    # Defaults to default.
    attr_accessor :mode
    # The payment method.
    attr_accessor :method
    # The payment receiver email
    attr_accessor :receiver_email
    # Set the payment currency.
    # Defaults to BRL.
    attr_accessor :currency
    # Set the extra amount applied to the transaction's total.
    # It's considered as an extra charge when positive, or a discount if
    # negative.
    attr_accessor :extra_amount
    # Determines for which url PagSeguro will send the order related
    # notifications codes.
    # Optional. Any change happens in the transaction status, a new notification
    # request will be send to this url. You can use that for update the related
    # order.
    attr_accessor :notification_url
    # The reference code identifies the order you placed on the payment request.
    # It's used by the store and can be something like the order id.
    attr_accessor :reference
    # The payer information (who is sending money).
    attr_reader :sender
    # The shipping information.
    attr_reader :shipping
    # The credit card object data
    attr_reader :credit_card

    # The email that identifies the request. Defaults to PagSeguro.email
    attr_accessor :email
    # The token that identifies the request. Defaults to PagSeguro.token
    attr_accessor :token

    # Calls the PagSeguro web service and register this transaction for
    # direct payment.
    def register
      params = Serializer.new(self).to_params.merge({
        email: email,
        token: token
      })
      Response.new Request.post("transactions", params)
    end

    # Normalize the sender object.
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    # Normalize the shipping object.
    def shipping=(shipping)
      @shipping = ensure_type(Shipping, shipping)
    end

    # Hold the transaction's items.
    def items
      @items ||= Items.new
    end

    # Normalize the items list.
    def items=(_items)
      _items.each {|item| items << item }
    end

    # Normalize the credit card object.
    def credit_card=(credit_card)
      @credit_card = ensure_type(CreditCard, credit_card)
    end

    private

    def before_initialize
      self.currency = "BRL"
      self.mode = "default"
      self.email    = PagSeguro.email
      self.token    = PagSeguro.token
    end

    def endpoint
      PagSeguro.api_url("transactions")
    end

  end
end
