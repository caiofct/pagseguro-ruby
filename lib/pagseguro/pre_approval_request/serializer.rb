module PagSeguro
  class PreApprovalRequest
    class Serializer
      # The pre-approval request that will be serialized.
      attr_reader :pre_approval_request

      def initialize(pre_approval_request)
        @pre_approval_request = pre_approval_request
      end

      def to_params
        # Base params
        params[:redirectURL] = pre_approval_request.redirect_url
        params[:reviewUrl] = pre_approval_request.review_url
        params[:reference] = pre_approval_request.reference

        # Sender
        serialize_sender(pre_approval_request.sender)

        # Pre-Approval
        serialize_pre_approval(pre_approval_request.pre_approval)
        
        # Deleting the nil params
        params.delete_if {|key, value| value.nil? }

        params
      end

      private
      def params
        @params ||= {}
      end

      def serialize_pre_approval(pre_approval)
        return unless pre_approval

        params[:preApprovalCharge] = pre_approval.pre_approval_charge
        params[:preApprovalName] = pre_approval.pre_approval_name
        params[:preApprovalDetails] = pre_approval.pre_approval_details
        params[:preApprovalAmountPerPayment] = to_amount(pre_approval.pre_approval_amount_per_payment)
        params[:preApprovalPeriod] = pre_approval.pre_approval_period
        params[:preApprovalInitialDate] = pre_approval.pre_approval_initial_date
        params[:preApprovalFinalDate] = pre_approval.pre_approval_final_date
        params[:preApprovalMaxTotalAmount] = to_amount(pre_approval.pre_approval_max_total_amount)
        params[:preApprovalMaxAmountPerPeriod] = to_amount(pre_approval.pre_approval_max_amount_per_period)
        params[:preApprovalDayOfYear] = pre_approval.pre_approval_day_of_year
        params[:preApprovalDayOfMonth] = pre_approval.pre_approval_day_of_month
        params[:preApprovalDayOfWeek] = pre_approval.pre_approval_day_of_week
      end

      def serialize_sender(sender)
        return unless sender

        params[:senderName] = sender.name
        params[:senderEmail] =  sender.email
        params[:senderCPF] = sender.cpf

        serialize_phone(sender.phone)
        serialize_address(sender.address)
      end

      def serialize_phone(phone)
        return unless phone

        params[:senderAreaCode] = phone.area_code
        params[:senderPhone] = phone.number
      end

      def serialize_address(address)
        return unless address

        params[:senderAddressCountry] = address.country
        params[:senderAddressState] = address.state
        params[:senderAddressCity] = address.city
        params[:senderAddressPostalCode] = address.postal_code
        params[:senderAddressDistrict] = address.district
        params[:senderAddressStreet] = address.street
        params[:senderAddressNumber] = address.number
        params[:senderAddressComplement] = address.complement
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end
