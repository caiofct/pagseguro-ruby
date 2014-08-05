module PagSeguro
  class PreApprovalStatus
    STATUSES = {
      "INITIATED" => :initiated,
      "PENDING" => :pending,
      "ACTIVE" => :active,
      "CANCELLED" => :cancelled,
      "CANCELLED_BY_RECEIVER" => :cancelled_by_receiver,
    }.freeze

    # The payment status id.
    attr_reader :id

    def initialize(id)
      @id = id
    end

    # Dynamically define helpers.
    STATUSES.each do |id, _status|
      define_method "#{_status}?" do
        _status == status
      end
    end

    # Return a readable status.
    def status
      STATUSES.fetch(id.to_s) { raise "PagSeguro::PreApprovalStatus#id isn't mapped" }
    end
  end
end
