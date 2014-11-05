class Gateway < ActiveRecord::Base

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

  class_attribute :available_gateways
  self.available_gateways = []

  def self.register name
    self.available_gateways << self.new(module_name: name)
  end

  def available_settings
    []
  end

  private

  def include_gateway_module
    return unless module_name = self.module_name
    class_eval do
      include "#{module_name}::Models::Gateway".constantize
    end
  end

end
