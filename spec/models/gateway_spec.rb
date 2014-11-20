require 'rails_helper'

RSpec.describe Gateway, type: :model do
  describe "asociations" do
    it{ is_expected.to belong_to :initiative }
  end

  describe "validations" do
    it{ is_expected.to validate_presence_of :initiative }
    it{ is_expected.to validate_presence_of :module_name }
    it{ is_expected.to validate_numericality_of(:ordering).only_integer }
  end
  
  describe ".register" do
    it "should add to available gateways" do
      Gateway.register 'ProductionGateway'
      expect(Rails.application.config.available_gateways.last.module_name).to eq 'ProductionGateway'
    end
  end

  describe ".available_gateways" do
    subject{ Gateway.available_gateways }
    it{ is_expected.to eq Rails.application.config.available_gateways  }
  end

  # State machine specs
  describe "#draft?" do
    subject{ gateway.draft? }

    context "when gateway is draft" do
      let(:gateway){ draft_gateway }
      it{ is_expected.to eq true }
    end

    context "when gateway is not draft" do
      let(:gateway){ production_gateway }
      it{ is_expected.to eq false }
    end
  end

  describe "#production?" do
    subject{ gateway.production? }

    context "when gateway is production" do
      let(:gateway){ production_gateway }
      it{ is_expected.to eq true }
    end

    context "when gateway is not production" do
      let(:gateway){ draft_gateway }
      it{ is_expected.to eq false }
    end
  end

  describe "#sandbox?" do
    subject{ gateway.sandbox? }

    context "when gateway is sandbox" do
      let(:gateway){ sandbox_gateway }
      it{ is_expected.to eq true }
    end

    context "when gateway is not sandbox" do
      let(:gateway){ draft_gateway }
      it{ is_expected.to eq false }
    end
  end

  # State machine transitions
  describe "#use_production" do
    subject{ gateway.use_production }

    context "when gateway is sandbox" do
      let(:gateway){ sandbox_gateway }
      it{ is_expected.to eq true }
    end

    context "when gateway is draft" do
      let(:gateway){ draft_gateway }
      it{ is_expected.to eq true }
    end

    context "when gateway is production" do
      let(:gateway){ production_gateway }
      it{ is_expected.to eq false }
    end
  end

  describe "#use_sandbox" do
    subject{ gateway.use_sandbox }

    context "when gateway is sandbox" do
      let(:gateway){ sandbox_gateway }
      it{ is_expected.to eq false }
    end

    context "when gateway is draft" do
      let(:gateway){ draft_gateway }
      it{ is_expected.to eq true }
    end

    context "when gateway is production" do
      let(:gateway){ production_gateway }
      it{ is_expected.to eq true }
    end
  end

  describe "#revert_to_draft" do
    subject{ gateway.revert_to_draft }

    context "when gateway is sandbox" do
      let(:gateway){ sandbox_gateway }
      it{ is_expected.to eq true }
    end

    context "when gateway is draft" do
      let(:gateway){ draft_gateway }
      it{ is_expected.to eq false }
    end

    context "when gateway is production" do
      let(:gateway){ production_gateway }
      it{ is_expected.to eq true }
    end
  end
end
