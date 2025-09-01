require 'yaml'

class InputParser
  EXEMPT_KEYWORDS = YAML.load_file(File.join(__dir__, '../config/product_categories.yml'))['exempt_keywords'].freeze

  def self.parse(input)
    words = input.split(' ')
    quantity = words[0].to_i
    price = words[-1].to_f
    is_imported = input.include?('imported')
    product_name = is_imported ? words[2..-3].join(' ') : words[1..-3].join(' ')
    is_exempt = check_exempt(product_name)

    { quantity: quantity, price: price, exempt: is_exempt, imported: is_imported, product_name: product_name }
  end

  private

  def self.check_exempt(product_name)
    EXEMPT_KEYWORDS.any? { |keyword| product_name.include?(keyword) }
  end
end
