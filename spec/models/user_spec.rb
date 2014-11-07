require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "asociations" do
    it{ is_expected.to have_many :initiatives }
    it{ is_expected.to have_many :contributions }
  end
end
