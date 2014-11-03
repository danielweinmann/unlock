#coding: utf-8

class Contribution < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :initiative
  belongs_to :gateway
  store_accessor :gateway_data

  validates_presence_of :user, :initiative, :gateway, :value
  validates :value, numericality: { only_integer: true, greater_than_or_equal_to: 5 }, allow_blank: true
  validate :presence_of_user_and_initiative_attributes

  accepts_nested_attributes_for :user
  
  after_initialize :include_gateway_module

  def self.visible
    with_state(:active).joins(:gateway).where("gateways.state = contributions.gateway_state").order("updated_at DESC")
  end
  
  def self.not_pending
    without_state(:pending).joins(:initiative).joins(:gateway).where("gateways.state = contributions.gateway_state").order("updated_at DESC")
  end
  
  state_machine initial: :pending do

    state :pending
    state :active
    state :suspended

    event :activate do
      transition [:pending, :suspended] => :active
    end

    event :suspend do
      transition :active => :suspended
    end

  end

  private
  
  def include_gateway_module
    return unless self.gateway && module_name = self.gateway.module_name
    class_eval do
      include "#{module_name}::ActiveRecord::Contribution".constantize
    end
  end

  def presence_of_user_and_initiative_attributes
    return unless self.user.present? && self.initiative.present?
    %w(full_name document phone_area_code phone_number birthdate address_street address_number address_district address_city address_state address_zipcode).each do |attribute|
      unless self.user.attributes[attribute].present?
        self.errors.add("user.#{attribute}", "não pode ficar em branco")
      end
    end
    %w(permalink).each do |attribute|
      unless self.initiative.attributes[attribute].present?
        self.errors.add("initiative.#{attribute}", "não pode ficar em branco")
      end
    end
  end
  
end
