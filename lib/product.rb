class Product
	attr_reader :name, :price, :exempt, :imported

	def initialize(name:, price:, exempt:, imported:)
		@name = name
		@price = price
		@exempt = exempt
		@imported = imported
	end

	def exempt?
		@exempt
	end

	def imported?
		@imported
	end
end
