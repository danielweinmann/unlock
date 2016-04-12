module ContributionDecorator

  def display_value
    @display_value ||= humanized_money_with_symbol Money.new(self.value * 100, self.initiative.currency), no_cents_if_whole: false
  end

  def next_invoice_date
    date = nil
    day = self.created_at.strftime('%d').to_i
    until date do
      date = Date.strptime(day.to_s + Time.now.strftime('/%m/%Y'), '%d/%m/%Y') rescue nil
      day -= 1
    end
    date += 1.month if date < Time.now
    l date
  end

  def can_manage_contribution?
    policy(self.initiative).update? || policy(self).update?
  end
end
