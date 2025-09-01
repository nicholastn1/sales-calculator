require_relative '../serializer/input_parser'
require_relative '../lib/product'
require_relative '../lib/line_item'
require_relative '../lib/order'

items = []

loop do
  line = gets.chomp
  break if line.empty?
  items << line
end

input_items = items.map { |item| InputParser.parse(item) }.compact

line_items = input_items.map do |item|
  product = Product.new(
    name: item[:product_name],
    price: item[:price],
    exempt: item[:exempt],
    imported: item[:imported]
  )
  LineItem.new(product: product, quantity: item[:quantity])
end

order = Order.new(line_items)
order.receipt
