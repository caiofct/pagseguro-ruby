module PagSeguro
  class DirectPayment
    class Serializer
      # The direct payment that will be serialized.
      attr_reader :direct_payment

      def initialize(direct_payment)
        @direct_payment = direct_payment
      end

      def to_params

        params[:paymentMode] = direct_payment.mode
        params[:paymentMethod] = direct_payment.method
        params[:receiverEmail] = PagSeguro.receiver_email
        params[:currency] = direct_payment.currency
        params[:extraAmount] = to_amount(direct_payment.extra_amount)
        params[:redirectURL] = direct_payment.redirect_url
        params[:notificationURL] = direct_payment.notification_url
        params[:reference] = direct_payment.reference

        direct_payment.items.each.with_index(1) do |item, index|
          serialize_item(item, index)
        end

        serialize_sender(direct_payment.sender)
        serialize_shipping(direct_payment.shipping)
        serialize_credit_card(direct_payment.credit_card)

        params.delete_if {|key, value| value.nil? }

        params
      end

      private
      def params
        @params ||= {}
      end

      def serialize_item(item, index)
        params["itemId#{index}"] = item.id
        params["itemDescription#{index}"] = item.description
        params["itemAmount#{index}"] = to_amount(item.amount)
        params["itemQuantity#{index}"] = item.quantity
        params["itemShippingCost#{index}"] = to_amount(item.shipping_cost)
        params["itemWeight#{index}"] = item.weight if item.weight
      end

      def serialize_sender(sender)
        return unless sender

        params[:senderEmail] =  sender.email
        params[:senderName] = sender.name
        params[:senderCPF] = sender.cpf
        params[:senderHash] = sender.sender_hash

        serialize_phone(sender.phone)
      end

      def serialize_phone(phone)
        return unless phone

        params[:senderAreaCode] = phone.area_code
        params[:senderPhone] = phone.number
      end

      def serialize_shipping(shipping)
        return unless shipping

        serialize_address(shipping.address)
      end

      def serialize_address(address)
        return unless address

        params[:shippingAddressCountry] = address.country
        params[:shippingAddressState] = address.state
        params[:shippingAddressCity] = address.city
        params[:shippingAddressPostalCode] = address.postal_code
        params[:shippingAddressDistrict] = address.district
        params[:shippingAddressStreet] = address.street
        params[:shippingAddressNumber] = address.number
        params[:shippingAddressComplement] = address.complement
      end

      def serialize_billing_address(billing_address)
        return unless billing_address

        params[:billingAddressCountry] = billing_address.country
        params[:billingAddressState] = billing_address.state
        params[:billingAddressCity] = billing_address.city
        params[:billingAddressPostalCode] = billing_address.postal_code
        params[:billingAddressDistrict] = billing_address.district
        params[:billingAddressStreet] = billing_address.street
        params[:billingAddressNumber] = billing_address.number
        params[:billingAddressComplement] = billing_address.complement
      end

      def serialize_credit_card(credit_card)
        return unless credit_card

        params[:creditCardToken] = credit_card.token
        params[:installmentQuantity] = credit_card.installment_quantity
        params[:installmentValue] = credit_card.installment_value
        params[:noInterestInstallmentQuantity] = credit_card.no_interest_installment_quantity

        params[:creditCardHolderName] = credit_card.holder_name
        params[:creditCardHolderCPF] = credit_card.holder_cpf
        params[:creditCardHolderBirthDate] = credit_card.holder_birth_date
        params[:creditCardHolderAreaCode] = credit_card.holder_area_code
        params[:creditCardHolderPhone] = credit_card.holder_phone

        serialize_billing_address(credit_card.billing_address) if credit_card.billing_address
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end
