class Initiative < ActiveRecord::Base
  
  belongs_to :user
  has_many :contributions
  has_many :gateways

  translates :name, :first_text, :second_text

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates_presence_of :user, :currency
  validates_uniqueness_of :permalink, allow_nil: true
  # Permalink cannot be a number, so it can't be confused with the id
  validates_format_of :permalink, :with => /[^\d]+/, allow_nil: true
  before_save do
    self.name = self.user.name if self.user && !self.name.present?
    self.permalink = self.permalink.gsub(/[^0-9a-z]/i, '').downcase if self.permalink
  end
  
  state_machine initial: :draft do

    state :draft
    state :published

    event :publish do
      transition :draft => :published, :if => :ready_for_publishing?
    end

    event :revert_to_draft do
      transition :published => :draft
    end

  end

  def self.home_page
    with_state(:published).order("(SELECT coalesce(sum(value), 0) FROM contributions INNER JOIN gateways ON contributions.gateway_id = gateways.id WHERE contributions.initiative_id = initiatives.id AND contributions.state = 'active' AND contributions.gateway_state = gateways.state) DESC, updated_at DESC")
  end

  unlock_auto_html_for :first_text, :second_text

  def to_param
    (self.permalink && self.permalink.parameterize) || (self.name && "#{self.id}-#{self.name.parameterize}") || self.id
  end

  def can_contribute?
    self.permalink.present? && self.gateways.without_state(:draft).exists? 
  end

  def ready_for_publishing?
    self.permalink.present? && self.gateways.with_state(:production).exists? 
  end

  def update_states_from_gateways!
    self.contributions.not_pending.each do |contribution|
      contribution.update_state_from_gateway!
    end
  end

  def available_gateways
    module_names = self.gateways.map(&:module_name)
    Gateway.available_gateways.select do |gateway|
      !module_names.include?(gateway.module_name)
    end
  end

end
