class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :initiatives

  before_create do
    self.name = self.email.match(/(.+)@/)[1] unless self.name.present?
  end

end
