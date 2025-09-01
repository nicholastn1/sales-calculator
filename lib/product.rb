require 'yaml'

class Product
	EXEMPT_KEYWORDS = YAML.load_file(File.join(__dir__, '../config/product_categories.yml'))['exempt_keywords'].freeze

	attr_reader :name, :price, :imported

	def initialize(name:, price:, imported:)
		@name = name
		@price = price
		@imported = imported
	end

	def exempt?
		EXEMPT_KEYWORDS.any? { |keyword| @name.include?(keyword) }
	end

	def imported?
		@imported
	end
end
