#coding: utf-8

class Initiative < ActiveRecord::Base
  
  belongs_to :user

  validates_presence_of :user, :name

  before_create do
    self.permalink = self.name unless self.permalink.present?
  end

  def to_param
    "#{self.id}-#{self.permalink.parameterize}"
  end

end
