# -*- encoding: utf-8 -*-
require "spec_helper"

describe PagSeguro::PreApprovalNotification::Serializer do
  context "for existing pre approvals" do
    let(:source) { File.read("./spec/fixtures/pre_approval_notification/success.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml.css("preApproval").first) }
    subject(:data) { serializer.serialize }

    it { expect(data).to include(name: "Light") }    
    it { expect(data).to include(code: "BC1C3A45353517BDD4A26FB17357B021") }
    it { expect(data).to include(date: Time.parse("2014-07-31T23:03:27.000-03:00")) }
    it { expect(data).to include(tracker: "3A0D05") }
    it { expect(data).to include(status: "ACTIVE") }
    it { expect(data).to include(reference: "56565") }
    it { expect(data).to include(lastEventDate: Time.parse("2014-07-31T23:12:10.000-03:00")) }
    it { expect(data).to include(charge: "AUTO") }

    it { expect(data[:sender]).to include(name: "JOHN DOE") }
    it { expect(data[:sender]).to include(email: "john@example.com") }
    it { expect(data[:sender][:phone]).to include(area_code: "11") }
    it { expect(data[:sender][:phone]).to include(number: "12345678") }

    it { expect(data[:sender][:address]).to include(street: "AV. BRIG. FARIA LIMA") }
    it { expect(data[:sender][:address]).to include(number: "1384") }
    it { expect(data[:sender][:address]).to include(complement: "5 ANDAR") }
    it { expect(data[:sender][:address]).to include(district: "JARDIM PAULISTANO") }
    it { expect(data[:sender][:address]).to include(city: "SAO PAULO") }
    it { expect(data[:sender][:address]).to include(state: "SP") }
    it { expect(data[:sender][:address]).to include(country: "BRA") }
    it { expect(data[:sender][:address]).to include(postal_code: "01452002") }
  end
end
