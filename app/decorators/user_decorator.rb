# coding: utf-8

module UserDecorator

  def display_name
    return self.full_name if self.name == self.email.match(/(.+)@/)[1] && self.full_name.present?
    self.name
  end

  def display_image
    if self.image.present?
      image_tag(self.image.url(:thumb))
    else
      image_tag('user.svg')
    end
  end

end
