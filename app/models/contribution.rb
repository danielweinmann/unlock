#coding: utf-8

class Contribution < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :initiative

  validates_presence_of :user, :initiative, :value
  validates :value, numericality: { only_integer: true, greater_than: 9 }

  accepts_nested_attributes_for :user
  
end
