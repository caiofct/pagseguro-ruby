require "spec_helper"

describe PagSeguro::PreApprovalNotification do
  describe ".find_by_notification_code" do
    it "finds pre approval by the given notificationCode" do
      PagSeguro::PreApprovalNotification.stub :load_from_response

      PagSeguro::Request
        .should_receive(:get)
        .with("pre-approvals/notifications/CODE")
        .and_return(double.as_null_object)

      PagSeguro::PreApprovalNotification.find_by_notification_code("CODE")
    end

    it "returns response with errors when request fails" do
      body = %[<?xml version="1.0"?><errors><error><code>1234</code><message>Sample error</message></error></errors>]
      FakeWeb.register_uri :get, %r[.+], status: [400, "Bad Request"], body: body, content_type: "text/xml"
      response = PagSeguro::PreApprovalNotification.find_by_notification_code("invalid")

      expect(response).to be_a(PagSeguro::PreApprovalNotification::Response)
      expect(response.errors).to include("Sample error")
    end
  end

  describe "attributes" do
    before do
      body = File.read("./spec/fixtures/pre_approval_notification/success.xml")
      FakeWeb.register_uri :get, %r[.+], body: body, content_type: "text/xml"
    end

    subject(:pre_approval) { PagSeguro::PreApprovalNotification.find_by_notification_code("CODE") }

    it { expect(pre_approval.sender).to be_a(PagSeguro::Sender) }
    it { expect(pre_approval.status).to be_a(PagSeguro::PreApprovalStatus) }
    it { expect(pre_approval.status.status).to be(:active) }
    it { expect(pre_approval.charge).to be(:auto) }
  end
end
