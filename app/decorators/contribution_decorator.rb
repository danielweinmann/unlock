module ContributionDecorator

  def display_value
    self.value.to_i
  end

  def next_invoice_date
    date = Date.strptime(self.created_at.strftime('%d') + Time.now.strftime('/%m/%Y'), '%d/%m/%Y')
    date += 1.month if date < Time.now
    l date
  end
  
end
