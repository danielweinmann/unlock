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
end
