require 'rails_helper'

RSpec.describe Contribution, type: :model do
  describe "asociations" do
    it{ is_expected.to belong_to :user }
    it{ is_expected.to belong_to :initiative }
    it{ is_expected.to belong_to :gateway }
  end

  describe "validations" do
    it{ is_expected.to validate_presence_of :user }
    it{ is_expected.to validate_presence_of :initiative }
    it{ is_expected.to validate_presence_of :gateway }
    it{ is_expected.to validate_presence_of :value }
    it{ is_expected.to validate_numericality_of(:value).only_integer.is_greater_than_or_equal_to(Contribution::MINIMUM_VALUE) }
  end

  # State machine specs
  describe "#pending?" do
    subject{ contribution.pending? }

    context "when contribution is pending" do
      let(:contribution){ pending_contribution }
      it{ is_expected.to eq true }
    end

    context "when contribution is not pending" do
      let(:contribution){ active_contribution }
      it{ is_expected.to eq false }
    end
  end

  describe "#active?" do
    subject{ contribution.active? }

    context "when contribution is active" do
      let(:contribution){ active_contribution }
      it{ is_expected.to eq true }
    end

    context "when contribution is not active" do
      let(:contribution){ pending_contribution }
      it{ is_expected.to eq false }
    end
  end

  describe "#suspended?" do
    subject{ contribution.suspended? }

    context "when contribution is suspended" do
      let(:contribution){ suspended_contribution }
      it{ is_expected.to eq true }
    end

    context "when contribution is not suspended" do
      let(:contribution){ pending_contribution }
      it{ is_expected.to eq false }
    end
  end
end
