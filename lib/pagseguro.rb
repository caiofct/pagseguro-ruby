require "bigdecimal"
require "forwardable"
require "time"

require "nokogiri"
require "aitch"
require "i18n"

require "pagseguro/version"
require "pagseguro/errors"
require "pagseguro/exceptions"
require "pagseguro/extensions/mass_assignment"
require "pagseguro/extensions/ensure_type"
require "pagseguro/address"
require "pagseguro/shipping"
require "pagseguro/phone"
require "pagseguro/item"
require "pagseguro/items"
require "pagseguro/payment_method"
require "pagseguro/payment_request"
require "pagseguro/payment_request/serializer"
require "pagseguro/payment_request/response"
require "pagseguro/payment_status"
require "pagseguro/pre_approval"
require "pagseguro/pre_approval_status"
require "pagseguro/pre_approval_request"
require "pagseguro/pre_approval_request/serializer"
require "pagseguro/pre_approval_request/response"
require "pagseguro/pre_approval_notification"
require "pagseguro/pre_approval_notification/serializer"
require "pagseguro/pre_approval_notification/response"

require "pagseguro/request"
require "pagseguro/report"
require "pagseguro/sender"
require "pagseguro/notification"
require "pagseguro/transaction"
require "pagseguro/transaction/response"
require "pagseguro/transaction/serializer"

require "pagseguro/session"
require "pagseguro/session/response"
require "pagseguro/session/serializer"

require "pagseguro/direct_payment"
require "pagseguro/direct_payment/serializer"
require "pagseguro/direct_payment/response"
require "pagseguro/credit_card"

I18n.load_path += Dir[File.expand_path("../../locales/*.yml", __FILE__)]

module PagSeguro
  class << self
    # Primary e-mail associated with this account.
    attr_accessor :email

    # The e-mail that will be displayed when sender is redirected
    # to PagSeguro.
    attr_accessor :receiver_email

    # The API token associated with this account.
    attr_accessor :token

    # The encoding that will be used.
    attr_accessor :encoding

    # The PagSeguro environment.
    # Can be: +development+, +production+ or +test+.
    attr_accessor :environment
  end

  self.encoding = "UTF-8"
  self.environment = :development

  # Register endpoints by environment.
  def self.uris
    @uris ||= {
      production: {
        api: "https://ws.pagseguro.uol.com.br/v2",
        site: "https://pagseguro.uol.com.br/v2"
      },
      development: {
        api:  'https://ws.sandbox.pagseguro.uol.com.br/v2',
        site: 'https://sandbox.pagseguro.uol.com.br/v2'
      },
      test: {
        api:  'https://ws.sandbox.pagseguro.uol.com.br/v2',
        site: 'https://sandbox.pagseguro.uol.com.br/v2'
      }
    }
  end

  # Return the root uri based on its type.
  # Current types are <tt>:api</tt> or <tt>:site</tt>
  def self.root_uri(type)
    root = uris.fetch(environment.to_sym) { raise InvalidEnvironmentError }
    root[type.to_sym]
  end

  # Set the global configuration.
  #
  #   PagSeguro.configure do |config|
  #     config.email = "john@example.com"
  #     config.token = "abc"
  #   end
  #
  def self.configure(&block)
    yield self
  end

  # The API endpoint.
  def self.api_url(path)
    File.join(root_uri(:api), path)
  end

  # The site url.
  def self.site_url(path)
    File.join(root_uri(:site), path)
  end
end
