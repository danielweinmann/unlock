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
end
