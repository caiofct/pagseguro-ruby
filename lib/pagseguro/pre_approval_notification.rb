module PagSeguro
  class PreApprovalNotification
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Set the available pre-approval charge.
    CHARGE = {
      manual: "manual",
      auto: "auto"
    }

    # The pre-approval name.
    attr_accessor :name

    # The transaction code.
    attr_accessor :code

    # The pre-approval date of creation.
    attr_accessor :date

    # The pre-approval tracker code.
    attr_accessor :tracker

    # The pre-approval status code
    attr_reader :status

    # The last event date of this pre-approval
    attr_accessor :lastEventDate

    # The pre-approval charge type (manual or auto)
    attr_reader :charge

    # The reference code identifies the order you placed on the payment request.
    # It's used by the store and can be something like the order id.
    attr_accessor :reference

    # The payer information (who is sending money).
    attr_reader :sender

    # Set the pre-approval errors.
    attr_reader :errors
    
    # Find a pre-approval by its code.
    # Return a PagSeguro::PreApprovalNotification instance.
    def self.find_by_code(code)
      load_from_response Request.get("pre-approvals/#{code}")
    end

    # Find a pre-approval by its notificationCode.
    # Return a PagSeguro::PreApprovalNotification instance.
    def self.find_by_notification_code(code)
      load_from_response Request.get("pre-approvals/notifications/#{code}")
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      if response.success? and response.xml?
        load_from_xml Nokogiri::XML(response.body).css("preApproval").first
      else
        Response.new Errors.new(response)
      end
    end

    # Serialize the XML object.
    def self.load_from_xml(xml) # :nodoc:
      new Serializer.new(xml).serialize
    end

    # Normalize the sender object.
    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    # Normalize charge of this pre-approval.
    def charge=(charge)
      charge = charge.downcase.to_sym
      CHARGE.fetch(charge) {
        raise InvalidChargeTypeError, "invalid #{charge.inspect} charge"
      }
      @charge = charge
    end

    # Normalize the payment status.
    def status=(status)
      @status = ensure_type(PreApprovalStatus, status)
    end

    private
    def after_initialize
      @errors = Errors.new
    end
  end
end
