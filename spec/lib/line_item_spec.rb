require 'spec_helper'
require_relative '../../lib/line_item'
require_relative '../../lib/product'

RSpec.describe LineItem do
  let(:book) { Product.new(name: 'book', price: 12.49, imported: false) }
  let(:imported_perfume) { Product.new(name: 'bottle of perfume', price: 47.50, imported: true) }
  let(:music_cd) { Product.new(name: 'music CD', price: 14.99, imported: false) }
  let(:imported_chocolates) { Product.new(name: 'box of chocolates', price: 10.00, imported: true) }

  describe '#initialize' do
    it 'creates a line item with product and quantity' do
      line_item = LineItem.new(product: book, quantity: 2)

      expect(line_item.product).to eq(book)
      expect(line_item.quantity).to eq(2)
    end
  end

  describe '#tax' do
    it 'calculates total tax for quantity 1' do
      line_item = LineItem.new(product: music_cd, quantity: 1)
      expect(line_item.tax).to eq(1.50)
    end

    it 'calculates total tax for multiple items' do
      line_item = LineItem.new(product: imported_chocolates, quantity: 2)
      expect(line_item.tax).to eq(1.00)
    end

    it 'returns 0 tax for exempt non-imported items' do
      line_item = LineItem.new(product: book, quantity: 3)
      expect(line_item.tax).to eq(0.00)
    end

    it 'calculates tax for imported items with quantity' do
      line_item = LineItem.new(product: imported_perfume, quantity: 2)
      expect(line_item.tax).to eq(14.30)
    end
  end

  describe '#total' do
    it 'calculates total with no tax' do
      line_item = LineItem.new(product: book, quantity: 1)
      expect(line_item.total).to eq(12.49)
    end

    it 'calculates total with tax for single item' do
      line_item = LineItem.new(product: music_cd, quantity: 1)
      expect(line_item.total).to be_within(0.01).of(16.49)
    end

    it 'calculates total with tax for multiple items' do
      line_item = LineItem.new(product: imported_perfume, quantity: 1)
      expect(line_item.total).to eq(54.65)
    end

    it 'calculates total for multiple imported chocolates' do
      line_item = LineItem.new(product: imported_chocolates, quantity: 2)
      expect(line_item.total).to eq(21.00)
    end
  end

  describe '#info' do
    it 'formats output for non-imported item' do
      line_item = LineItem.new(product: book, quantity: 1)
      expect(line_item.info).to eq('1 book: 12.49')
    end

    it 'formats output for imported item' do
      line_item = LineItem.new(product: imported_perfume, quantity: 1)
      expect(line_item.info).to eq('1 imported bottle of perfume: 54.65')
    end

    it 'formats output with multiple quantities' do
      line_item = LineItem.new(product: music_cd, quantity: 2)
      expect(line_item.info).to eq('2 music CD: 32.98')
    end

    it 'formats output for imported chocolates' do
      line_item = LineItem.new(product: imported_chocolates, quantity: 2)
      expect(line_item.info).to eq('2 imported box of chocolates: 21.00')
    end

    it 'formats decimal places correctly' do
      product = Product.new(name: 'test item', price: 10.00, imported: false)
      line_item = LineItem.new(product: product, quantity: 1)
      expect(line_item.info).to eq('1 test item: 11.00')
    end
  end

  describe '#display_name (private method)' do
    it 'adds "imported" prefix for imported products' do
      line_item = LineItem.new(product: imported_perfume, quantity: 1)
      display_name = line_item.send(:display_name)
      expect(display_name).to eq('imported bottle of perfume')
    end

    it 'does not add prefix for non-imported products' do
      line_item = LineItem.new(product: book, quantity: 1)
      display_name = line_item.send(:display_name)
      expect(display_name).to eq('book')
    end
  end

  context 'edge cases' do
    it 'handles zero quantity' do
      line_item = LineItem.new(product: book, quantity: 0)
      expect(line_item.tax).to eq(0.00)
      expect(line_item.total).to eq(0.00)
    end

    it 'handles negative quantity' do
      line_item = LineItem.new(product: music_cd, quantity: -1)
      expect(line_item.tax).to eq(-1.50)
      expect(line_item.total).to be_within(0.01).of(-16.49)
    end

    it 'handles very large quantities' do
      line_item = LineItem.new(product: book, quantity: 1000)
      expect(line_item.total).to eq(12490.00)
    end
  end
end
