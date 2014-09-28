# coding: utf-8

module InitiativeDecorator

  def total_value
    @total_value ||= self.contributions.with_state(:active).where(sandbox: self.sandbox).sum(:value).to_i
  end
  
  def total_contributions
    @total_contributions ||= self.contributions.with_state(:active).where(sandbox: self.sandbox).count
  end

  def margin
    return "0" unless self.image.width && self.image.height
    ratio = self.image.height.to_f / self.image.width
    return "0" if ratio <= 0.191
    "-#{(ratio / 2.0 * 100) - 19.1}%"
  end

end
