class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :initiatives
  has_many :contributions
  
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_validation do
    self.name = self.email.match(/(.+)@/)[1] unless self.name.present?
    %w(document phone_area_code phone_number address_zipcode).each do |attribute|
      self.send("#{attribute}=", self.send(attribute).scan(/\d/).join('')) if self.send(attribute)
    end
  end

end
