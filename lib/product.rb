class Product
	attr_reader :name, :price, :category

	EXEMPT_CATEGORIES = %i[book food medical].freeze

	def initialize(name:, price:, category: nil)
		@name = name
		@price = price
		@category = category
	end

	def exempt?
		EXEMPT_CATEGORIES.include?(@category)
	end

	def imported?
		@name.include?('imported')
	end
end
