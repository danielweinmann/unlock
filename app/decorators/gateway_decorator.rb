# coding: utf-8

module GatewayDecorator

  def display_title
    (self.title.present? && self.title) || self.name
  end
  
end
