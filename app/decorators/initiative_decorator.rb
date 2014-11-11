module InitiativeDecorator

  def display_currency(display_name = false)
    @display_currency ||= Money::Currency.new(self.currency)
    if display_name
      "#{@display_currency.symbol} - #{@display_currency.iso_code}"
    else
      @display_currency.symbol
    end
  end

  def total_value
    @total_value ||= self.contributions.visible.sum(:value).to_i
  end
  
  def total_contributions
    @total_contributions ||= self.contributions.visible.count
  end

  def margin
    return "0" unless self.image.width && self.image.height
    ratio = self.image.height.to_f / self.image.width
    return "0" if ratio <= 0.3333
    "-#{(ratio / 2.0 * 100) - 33.33}%"
  end

end
