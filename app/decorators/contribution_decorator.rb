module ContributionDecorator

  def display_value
    @display_value ||= humanized_money_with_symbol Money.new(self.value * 100, self.initiative.currency), no_cents_if_whole: false
  end

  def next_invoice_date
    date = Date.strptime(self.created_at.strftime('%d') + Time.now.strftime('/%m/%Y'), '%d/%m/%Y')
    date += 1.month if date < Time.now
    l date
  end
  
end
