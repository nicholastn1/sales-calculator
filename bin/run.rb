require_relative '../serializer/input_parser'

items = []

loop do
  line = gets.chomp
  break if line.empty?
  items << line
end

input_items = items.map { |item| InputParser.parse(item) }.compact

line_items = input_items.map { |item| LineItem.new(product: Product.new(item[:product_name], item[:price], item[:exempt], item[:imported]), quantity: item[:quantity]) }

order = Order.new(line_items)
order.receipt
