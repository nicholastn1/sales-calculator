require_relative 'line_item'

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

  def receipt
    @line_items.each do |item|
      puts item.info
    end
    puts "Sales Taxes: #{'%.2f' % total_tax}"
    puts "Total: #{'%.2f' % total_amount}"
  end
end
