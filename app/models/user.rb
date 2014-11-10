class User < ActiveRecord::Base
  ONLY_DIGITS_ATTRIBUTES = %w(document phone_area_code phone_number address_zipcode)

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :initiatives
  has_many :contributions
  
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_validation :extract_name_from_email
  before_validation :extract_digits_from_attributes

  private
  def extract_name_from_email
    self.name = self.email.match(/(.+)@/)[1] unless self.name.present?
  end

  def extract_digits_from_attributes
    ONLY_DIGITS_ATTRIBUTES.each{|attribute| extract_digits_from attribute }
  end 

  def extract_digits_from attribute
    self.attributes[attribute] && self.attributes[attribute].gsub!(/[^\d]/, '')
  end
end
