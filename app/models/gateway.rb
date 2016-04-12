class Gateway < ActiveRecord::Base

  translates :title, :ordering

  belongs_to :initiative
  validates :module_name, uniqueness: { scope: :initiative_id }
  validates_presence_of :initiative, :module_name
  validates :ordering, numericality: { only_integer: true }, allow_blank: true
  store_accessor :settings

  after_initialize :include_gateway_module

  state_machine initial: :draft do

    state :draft
    state :sandbox
    state :production

    event :use_sandbox do
      transition [:draft, :production] => :sandbox, :if => :has_sandbox?
    end

    event :use_production do
      transition [:draft, :sandbox] => :production
    end

    event :revert_to_draft do
      transition [:sandbox, :production] => :draft
    end

  end

  def self.ordered
    order("ordering_translations -> '#{I18n.locale}'")
  end

  def self.register name
    Rails.application.config.available_gateways << self.new(module_name: name)
  end

  def self.available_gateways
    Rails.application.config.available_gateways
  end

  def available_settings
    []
  end

  # Overriden in gateway modules
  def name
  end

  private

  def include_gateway_module
    return unless module_name = self.module_name
    class_eval do
      include "#{module_name}::Models::Gateway".constantize
    end
  end

end
