require 'yaml'

class InputParser
  EXEMPT_KEYWORDS = YAML.load_file(File.join(__dir__, '../config/product_categories.yml'))['exempt_keywords'].freeze

  def self.parse(input)
    return nil if input.nil? || input.strip.empty?

    words = input.split(' ')
    return nil if words.length < 4 || !input.include?('at')

    quantity = words[0].to_i
    return nil if quantity <= 0

    price = words[-1].to_f
    return nil if price <= 0

    is_imported = input.include?('imported')
    product_name = is_imported ? words[2..-3].join(' ') : words[1..-3].join(' ')
    return nil if product_name.strip.empty?

    is_exempt = check_exempt(product_name)

    { quantity: quantity, price: price, exempt: is_exempt, imported: is_imported, product_name: product_name }
  end

  private

  def self.check_exempt(product_name)
    EXEMPT_KEYWORDS.any? { |keyword| product_name.include?(keyword) }
  end
end
