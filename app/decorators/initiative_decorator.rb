# coding: utf-8

module InitiativeDecorator

  def total_value
    number_to_currency self.contributions.sum(:value)
  end
  
  def total_contributions
    self.contributions.count
  end

end
