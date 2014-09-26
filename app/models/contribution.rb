#coding: utf-8

class Contribution < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :initiative

  validates_presence_of :user, :initiative, :value
  validates :value, numericality: { only_integer: true, greater_than: 9 }
  validate :presence_of_user_attributes

  accepts_nested_attributes_for :user
  
  private
  
  def presence_of_user_attributes
    return unless self.user.present?
    %w(full_name document phone_area_code phone_number birthdate address_street address_number address_complement address_district address_city address_state address_zipcode).each do |attribute|
      unless self.user.attributes[attribute].present?
        self.errors.add("user.#{attribute}", "não pode ficar em branco")
      end
    end
  end
  
end
