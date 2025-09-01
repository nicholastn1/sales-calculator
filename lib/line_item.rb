require_relative 'product'
require_relative 'tax_calculator'

class LineItem
	attr_reader :product, :quantity

	def initialize(product:, quantity:)
		@product = product
		@quantity = quantity
	end

	def tax
		TaxCalculator.calculate(product) * quantity
	end

	def total
		(product.price * quantity) + tax
	end

	def info
		"#{quantity} #{display_name}: #{'%.2f' % total}"
	end

	private

	def display_name
		product.imported ? "imported #{product.name}" : product.name
	end
end
