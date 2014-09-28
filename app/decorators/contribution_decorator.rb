# coding: utf-8

module ContributionDecorator

  def display_value
    self.value.to_i
  end
  
  def margin
    return "0" unless self.initiative.image.width && self.initiative.image.height
    ratio = self.initiative.image.height.to_f / self.initiative.image.width
    return "0" if ratio <= 0.191
    "-#{(ratio / 2.0 * 100) - 19.1}%"
  end

end
