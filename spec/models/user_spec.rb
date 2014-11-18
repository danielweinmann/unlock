require 'rails_helper'

RSpec.describe User, type: :model do
  describe "asociations" do
    it{ is_expected.to have_many :initiatives }
    it{ is_expected.to have_many :contributions }
  end

  describe "#set_locale" do
    before do
      visitor_user.set_locale :pt
    end

    it "should change user locale" do
      expect(visitor_user.locale).to eq 'pt'
    end
  end

  describe "#valid?" do
    let(:user_name){ nil }
    let(:user) do
      User.new({
        name: user_name, 
        email: 'foo@bar.com', 
        document: '111.111.111-11', 
        phone_area_code: '(11)', 
        phone_number: '1111-1111', 
        address_zipcode: '11111-111'
      })
    end

    before do
      user.valid?
    end

    it "should extract name from email when name is nil" do
      expect(user.name).to eq 'foo'
    end

    %w(document phone_area_code phone_number address_zipcode).each do |attribute|
      it "should remove characters that are not digits from #{attribute}" do
        expect(user.send(attribute)).to eq user.send(attribute).gsub(/[^\d]/, '')
      end
    end

    context "when name is not nil" do
      let(:user_name){ 'Foo Bar' }
      it "should keep name" do
        expect(user.name).to eq user_name
      end
    end
  end
end
