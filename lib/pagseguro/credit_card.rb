module PagSeguro
  class CreditCard
    include Extensions::MassAssignment
    include Extensions::EnsureType

    # The Credit Card Token
    attr_accessor :token
    # The installment quantity.
    attr_accessor :installment_quantity
    # The installment value.
    attr_accessor :installment_value
    # The amount of installments without interest
    attr_accessor :no_interest_installment_quantity

    # Set the card holder name
    attr_accessor :holder_name
    # Set the card holder cpf
    attr_accessor :holder_cpf
    # Set the card holder birth date
    attr_accessor :holder_birth_date
    # Set the card holder area code
    attr_accessor :holder_area_code
    # Set the card holder area code
    attr_accessor :holder_phone

    # Get the billing address object.
    attr_reader :billing_address

    # Set the billing address info.
    def billing_address=(billing_address)
      @billing_address = ensure_type(Address, billing_address)
    end
  end
end
