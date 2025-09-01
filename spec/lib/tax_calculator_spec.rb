require 'spec_helper'
require_relative '../../lib/tax_calculator'
require_relative '../../lib/product'

RSpec.describe TaxCalculator do
  describe '.calculate' do
    context 'for exempt products (books, food, medical)' do
      context 'when not imported' do
        it 'applies 0% tax' do
          product = Product.new(name: 'book', price: 12.49, imported: false)
          tax = TaxCalculator.calculate(product)
          expect(tax).to eq(0.00)
        end

        it 'applies 0% tax for chocolate' do
          product = Product.new(name: 'chocolate bar', price: 0.85, imported: false)
          tax = TaxCalculator.calculate(product)
          expect(tax).to eq(0.00)
        end
      end

      context 'when imported' do
        it 'applies 5% import tax only' do
          product = Product.new(name: 'imported box of chocolates', price: 10.00, imported: true)
          tax = TaxCalculator.calculate(product)
          expect(tax).to eq(0.50)
        end

        it 'rounds up to nearest 0.05 for imported book' do
          product = Product.new(name: 'imported book', price: 12.49, imported: true)
          tax = TaxCalculator.calculate(product)
          expected = (12.49 * 0.05 * 20).ceil / 20.0
          expect(tax).to eq(expected)
        end
      end
    end

    context 'for non-exempt products' do
      context 'when not imported' do
        it 'applies 10% basic sales tax' do
          product = Product.new(name: 'music CD', price: 14.99, imported: false)
          tax = TaxCalculator.calculate(product)
          expect(tax).to eq(1.50)
        end

        it 'rounds up to nearest 0.05' do
          product = Product.new(name: 'bottle of perfume', price: 18.99, imported: false)
          tax = TaxCalculator.calculate(product)
          expect(tax).to eq(1.90)
        end
      end

      context 'when imported' do
        it 'applies 15% combined tax (10% + 5%)' do
          product = Product.new(name: 'imported bottle of perfume', price: 27.99, imported: true)
          tax = TaxCalculator.calculate(product)
          expect(tax).to eq(4.20)
        end

        it 'applies correct tax for imported perfume at 47.50' do
          product = Product.new(name: 'imported bottle of perfume', price: 47.50, imported: true)
          tax = TaxCalculator.calculate(product)
          expect(tax).to eq(7.15)
        end
      end
    end

    context 'rounding rules' do
      it 'rounds 0.5625 up to 0.60' do
        product = Product.new(name: 'imported chocolates', price: 11.25, imported: true)
        tax = TaxCalculator.calculate(product)
        expect(tax).to eq(0.60)
      end

      it 'rounds 0.99 up to 1.00' do
        product = Product.new(name: 'item', price: 9.90, imported: false)
        tax = TaxCalculator.calculate(product)
        expect(tax).to eq(1.00)
      end

      it 'keeps exact 0.05 multiples unchanged' do
        product = Product.new(name: 'item', price: 10.00, imported: false)
        tax = TaxCalculator.calculate(product)
        expect(tax).to eq(1.00)
      end

      it 'rounds 1.499 up to 1.50' do
        product = Product.new(name: 'music CD', price: 14.99, imported: false)
        tax = TaxCalculator.calculate(product)
        expect(tax).to eq(1.50)
      end
    end

    context 'edge cases' do
      it 'handles zero price' do
        product = Product.new(name: 'free item', price: 0, imported: false)
        tax = TaxCalculator.calculate(product)
        expect(tax).to eq(0.00)
      end

      it 'handles very small prices' do
        product = Product.new(name: 'cheap item', price: 0.01, imported: false)
        tax = TaxCalculator.calculate(product)
        expect(tax).to eq(0.05)
      end

      it 'handles negative prices' do
        product = Product.new(name: 'refund item', price: -10.00, imported: false)
        tax = TaxCalculator.calculate(product)
        expect(tax).to eq(-1.00)
      end

      it 'handles very large prices' do
        product = Product.new(name: 'luxury item', price: 10000.00, imported: true)
        tax = TaxCalculator.calculate(product)
        expect(tax).to eq(1500.05)
      end
    end
  end
end
