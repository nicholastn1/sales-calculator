class LineItem
	attr_reader :product, :quantity

	def initialize(product:, quantity:)
		@product = product
		@quantity = quantity
	end

	def tax
		# TODO: implement tax calculation
	end

	def total
		# TODO: add tax
		product.price * quantity
	end
end
