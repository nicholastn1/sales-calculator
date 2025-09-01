require_relative 'line_item'

class Order
  attr_reader :line_items

  def initialize(line_items)
    @line_items = line_items
  end

  def receipt
    # TODO: implement
  end
end
