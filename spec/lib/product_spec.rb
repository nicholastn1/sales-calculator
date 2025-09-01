require 'spec_helper'
require_relative '../../lib/product'

RSpec.describe Product do
  describe '#initialize' do
    it 'creates a product with name, price, and imported status' do
      product = Product.new(name: 'book', price: 12.49, imported: false)

      expect(product.name).to eq('book')
      expect(product.price).to eq(12.49)
      expect(product.imported).to eq(false)
    end
  end

  describe '#exempt?' do
    context 'when product is exempt from basic sales tax' do
      it 'returns true for books' do
        product = Product.new(name: 'book', price: 12.49, imported: false)
        expect(product.exempt?).to be true
      end

      it 'returns true for products containing "books"' do
        product = Product.new(name: 'programming books', price: 45.99, imported: false)
        expect(product.exempt?).to be true
      end

      it 'returns true for chocolate' do
        product = Product.new(name: 'chocolate bar', price: 0.85, imported: false)
        expect(product.exempt?).to be true
      end

      it 'returns true for products containing "chocolates"' do
        product = Product.new(name: 'box of chocolates', price: 10.00, imported: false)
        expect(product.exempt?).to be true
      end

      it 'returns true for medical products with "pills"' do
        product = Product.new(name: 'packet of headache pills', price: 9.75, imported: false)
        expect(product.exempt?).to be true
      end

      it 'returns true for medical products with "medicine"' do
        product = Product.new(name: 'bottle of medicine', price: 15.00, imported: false)
        expect(product.exempt?).to be true
      end

      it 'returns true for medical products with "headache"' do
        product = Product.new(name: 'headache relief', price: 5.00, imported: false)
        expect(product.exempt?).to be true
      end
    end

    context 'when product is not exempt' do
      it 'returns false for perfume' do
        product = Product.new(name: 'bottle of perfume', price: 47.50, imported: true)
        expect(product.exempt?).to be false
      end

      it 'returns false for music CD' do
        product = Product.new(name: 'music CD', price: 14.99, imported: false)
        expect(product.exempt?).to be false
      end

      it 'returns false for general products' do
        product = Product.new(name: 'laptop', price: 999.99, imported: false)
        expect(product.exempt?).to be false
      end
    end
  end

  describe '#imported?' do
    it 'returns true when product is imported' do
      product = Product.new(name: 'bottle of perfume', price: 47.50, imported: true)
      expect(product.imported?).to be true
    end

    it 'returns false when product is not imported' do
      product = Product.new(name: 'book', price: 12.49, imported: false)
      expect(product.imported?).to be false
    end
  end

  context 'edge cases' do
    it 'handles empty product names' do
      product = Product.new(name: '', price: 10.00, imported: false)
      expect(product.exempt?).to be false
    end

    it 'handles zero price' do
      product = Product.new(name: 'free sample', price: 0, imported: false)
      expect(product.price).to eq(0)
    end

    it 'handles negative price' do
      product = Product.new(name: 'discount item', price: -5.00, imported: false)
      expect(product.price).to eq(-5.00)
    end

    it 'handles very large prices' do
      product = Product.new(name: 'luxury item', price: 999999.99, imported: true)
      expect(product.price).to eq(999999.99)
    end
  end
end
