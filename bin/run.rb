require_relative '../serializer/input_parser'

items = []

loop do
  line = gets.chomp
  break if line.empty?
  items << line
end

line_items = items.map { |item| InputParser.parse(item) }.compact

puts line_items.inspect

# receipt = Receipt.new(line_items)
# receipt.print
