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
    return unless self.user.present? && self.initiative.present?
    %w(full_name document phone_area_code phone_number birthdate address_street address_number address_complement address_district address_city address_state address_zipcode).each do |attribute|
      unless self.user.attributes[attribute].present?
        self.errors.add("user.#{attribute}", "não pode ficar em branco")
      end
    end
    %w(moip_token moip_key permalink).each do |attribute|
      unless self.initiative.attributes[attribute].present?
        self.errors.add("initiative.#{attribute}", "não pode ficar em branco")
      end
    end
  end
  
  def plan_code
    "#{self.initiative.permalink}#{self.value.to_i}#{'sandbox' if self.initiative.sandbox?}"
  end
  
  def customer_code
    "#{self.initiative.permalink}#{self.user.id}#{'sandbox' if self.initiative.sandbox?}"
  end
  
  def subscription_code
    "#{self.initiative.permalink}#{self.id}#{'sandbox' if self.initiative.sandbox?}"
  end
  
end
