require 'rails_helper'

RSpec.describe Initiative, type: :model do
  describe "asociations" do
    it{ is_expected.to belong_to :user }
    it{ is_expected.to have_many :contributions }
    it{ is_expected.to have_many :gateways }
  end

  describe "validations" do

    it{ is_expected.to validate_presence_of :user }
    it{ is_expected.to validate_presence_of :currency }
    it{ is_expected.to validate_uniqueness_of :permalink }
    it{ is_expected.to allow_value('foo', nil).for(:permalink) }
    it{ is_expected.to_not allow_value('9').for(:permalink) }
  end
end
