#coding: utf-8

class Contribution < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :initiative

  validates_presence_of :user, :initiative, :value
  validates :value, numericality: { only_integer: true, greater_than_or_equal_to: 10 }, allow_blank: true
  validate :presence_of_user_and_initiative_attributes

  accepts_nested_attributes_for :user
  
  def self.visible
    with_state(:active).joins(:initiative).where("initiatives.sandbox = contributions.sandbox").order("updated_at DESC")
  end
  
  def self.not_pending
    where("state <> 0 AND initiative_id IN (SELECT id FROM initiatives)").joins(:initiative).where("initiatives.sandbox = contributions.sandbox").order("updated_at DESC")
  end
  
  state_machine initial: :pending do

    state :pending, value: 0
    state :active, value: 1
    state :suspended, value: 2
    # state :expired, value: 3 # not currently used
    # state :overdue, value: 4 # not currently used
    state :canceled, value: 5
    # state :trial, value: 6 # not currently used

    event :activate do
      transition [:pending, :suspended] => :active
    end

    event :suspend do
      transition :active => :suspended
    end

    event :cancel do
      transition [:active, :suspended] => :canceled
    end

  end

  def plan_code
    "#{self.initiative.permalink[0..29]}#{self.value.to_i}#{'sandbox' if self.initiative.sandbox?}"
  end
  
  def customer_code
    "#{self.initiative.permalink[0..29]}#{self.user.id}#{'sandbox' if self.initiative.sandbox?}"
  end
  
  def subscription_code
    "#{self.initiative.permalink[0..29]}#{self.id}#{'sandbox' if self.initiative.sandbox?}"
  end
  
  def moip_auth
    { token: self.initiative.moip_token, key: self.initiative.moip_key, sandbox: self.initiative.sandbox? }
  end

  def moip_state
    begin
      response = Moip::Assinaturas::Subscription.details(self.subscription_code, moip_auth: self.moip_auth)
    rescue
      return nil
    end
    if response && response[:success]
      status = (response[:subscription]["status"].upcase rescue nil)
      case status
        when 'ACTIVE', 'OVERDUE'
          1
        when 'SUSPENDED', 'EXPIRED'
          2
        when 'CANCELED'
          5
      end
    end
  end

  def moip_state_name
    case self.moip_state
      when 1
        :active
      when 2
        :suspended
      when 5
        :canceled
    end
  end

  def update_state_from_moip!
    if self.state != self.moip_state
      case self.moip_state_name
        when :active
          self.activate!
        when :suspended
          self.suspend!
        when :canceled
          self.cancel!
      end
    end
  end
  
  private
  
  def presence_of_user_and_initiative_attributes
    return unless self.user.present? && self.initiative.present?
    %w(full_name document phone_area_code phone_number birthdate address_street address_number address_district address_city address_state address_zipcode).each do |attribute|
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
  
end
