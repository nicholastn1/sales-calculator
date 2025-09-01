class TaxCalculator
  def self.calculate(product)
    tax_rate = 0
    tax_rate += 0.1 if !product.exempt?
    tax_rate += 0.05 if product.imported?

    raw_tax = product.price * tax_rate

    (raw_tax * 20).ceil / 20.0
  end
end
