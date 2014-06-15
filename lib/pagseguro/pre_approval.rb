module PagSeguro
  class PreApproval
    # Set the available pre-approval charge.
    CHARGE = {
      manual: "manual",
      auto: "auto"
    }
    # Set the available pre-approval period.
    PERIOD = {
      weekly: "weekly",
      monthly: "monthly",
      bimonthly: "bimonthly",
      trimonthly: "trimonthly",
      semiannually: "semiannually",
      yearly: "yearly"
    }

    # Define the error classes for invalid type assignment.
    InvalidChargeTypeError = Class.new(StandardError)
    InvalidPeriodTypeError = Class.new(StandardError)

    include Extensions::MassAssignment
    include Extensions::EnsureType

    # Indicates whether the subscription will be charged by the PagSeguro (auto)
    # or by the Store (manual).
    # Presence: Mandatory
    # Type: CHARGE
    attr_reader :pre_approval_charge
    # The subscription name
    # Presence: Mandatory
    # Type: string (max of 100 characters)
    attr_accessor :pre_approval_name
    # The subscription details
    # Presence: Optional
    # Type: string (max of 255 characters)
    attr_accessor :pre_approval_details
    # Exact amount of each recurrent payment
    # Presence: Mandatory
    # Type: Decimal
    attr_accessor :pre_approval_amount_per_payment
    # The payment periodicity. Can be one of (weekly, monthly, bimonthly, trimonthly,
    # semiannually, yearly)
    # Presence: Mandatory
    # Type: PERIOD
    attr_reader :pre_approval_period
    # The subscription's initial date to be considered valid
    # Presence: Optional (Can only be used with the manual charge option)
    # Type: DateTime in the format: YYYY-MM-DDThh:mm:ss.sTZD (This date cannot be
    # greater than Now + 2 years)
    attr_accessor :pre_approval_initial_date
    # The subscription's final date to be considered valid
    # Presence: Mandatory
    # Type: DateTime in the format: YYYY-MM-DDThh:mm:ss.sTZD (This date cannot be
    # greater than InitialDate + 2 years)
    attr_accessor :pre_approval_final_date
    # The max amount that can be charged in the subscription term's month regardless the periodicity
    # Presence: Mandatory for the manual charge and Optional for the auto charge
    # Type: Decimal
    attr_accessor :pre_approval_max_amount_per_period
    # Maximum amount that can be charged during the entire subscription term
    # Presence: Mandatory
    # Type: Decimal
    attr_accessor :pre_approval_max_total_amount
    # The day in the year when the subscription will be charged
    # Presence: Mandatory only for manual charge and when the period is yearly
    # Type: Integer
    attr_accessor :pre_approval_day_of_year
    # The day in the month when the subscription will be charged
    # Presence: Mandatory only for manual charge and when the period is one of: monthly, bimonthly or trimonthly
    # Type: Integer
    attr_accessor :pre_approval_day_of_month
    # The day in the week when the subscription will be charged
    # Presence: Mandatory only for manual charge and when the period is weekly
    # Type: Integer
    attr_accessor :pre_approval_day_of_week

    # Set pre_approval_charge.
    # It raises the PagSeguro::PreApproval::InvalidChargeTypeError exception
    # when trying to assign an invalid charge name.
    def pre_approval_charge=(pre_approval_charge)
      pre_approval_charge = pre_approval_charge.to_sym
      CHARGE.fetch(pre_approval_charge) {
        raise InvalidChargeTypeError, "invalid #{pre_approval_charge.inspect} charge"
      }
      @pre_approval_charge = pre_approval_charge
    end

    # Set pre_approval_period.
    # It raises the PagSeguro::PreApproval::InvalidPeriodTypeError exception
    # when trying to assign an invalid period name.
    def pre_approval_period=(pre_approval_period)
      pre_approval_period = pre_approval_period.to_sym
      PERIOD.fetch(pre_approval_period) {
        raise InvalidPeriodTypeError, "invalid #{pre_approval_period.inspect} period"
      }
      @pre_approval_period = pre_approval_period
    end
  end
end
