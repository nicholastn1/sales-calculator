class Order
  attr_reader :line_items

  def initialize(line_items)
    @line_items = line_items
  end

  def total_tax
    @line_items.sum(&:tax)
  end

  def total_amount
    @line_items.sum(&:total)
  end

  def to_s
    receipt_lines = @line_items.map(&:info)
    receipt_lines << "Sales Taxes: #{'%.2f' % total_tax}"
    receipt_lines << "Total: #{'%.2f' % total_amount}"

    receipt_lines.join("\n")
  end
end
