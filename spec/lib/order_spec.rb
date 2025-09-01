require 'spec_helper'
require 'stringio'
require_relative '../../lib/order'
require_relative '../../lib/line_item'
require_relative '../../lib/product'

RSpec.describe Order do
  let(:book) { Product.new(name: 'book', price: 12.49, imported: false) }
  let(:music_cd) { Product.new(name: 'music CD', price: 14.99, imported: false) }
  let(:chocolate_bar) { Product.new(name: 'chocolate bar', price: 0.85, imported: false) }
  let(:imported_chocolates) { Product.new(name: 'box of chocolates', price: 10.00, imported: true) }
  let(:imported_perfume) { Product.new(name: 'bottle of perfume', price: 47.50, imported: true) }

  describe '#initialize' do
    it 'creates an order with line items' do
      line_item1 = LineItem.new(product: book, quantity: 1)
      line_item2 = LineItem.new(product: music_cd, quantity: 1)
      order = Order.new([line_item1, line_item2])

      expect(order.line_items).to eq([line_item1, line_item2])
    end

    it 'accepts empty array of line items' do
      order = Order.new([])
      expect(order.line_items).to eq([])
    end
  end

  describe '#total_tax' do
    it 'calculates total tax for multiple items' do
      line_item1 = LineItem.new(product: book, quantity: 1)
      line_item2 = LineItem.new(product: music_cd, quantity: 1)
      line_item3 = LineItem.new(product: chocolate_bar, quantity: 1)

      order = Order.new([line_item1, line_item2, line_item3])
      expect(order.total_tax).to eq(1.50)
    end

    it 'calculates total tax for imported items' do
      line_item1 = LineItem.new(product: imported_chocolates, quantity: 1)
      line_item2 = LineItem.new(product: imported_perfume, quantity: 1)

      order = Order.new([line_item1, line_item2])
      expect(order.total_tax).to eq(7.65)
    end

    it 'returns 0 for empty order' do
      order = Order.new([])
      expect(order.total_tax).to eq(0)
    end

    it 'calculates tax for test case 1' do
      book_item = LineItem.new(product: book, quantity: 2)
      cd_item = LineItem.new(product: music_cd, quantity: 1)
      chocolate_item = LineItem.new(product: chocolate_bar, quantity: 1)

      order = Order.new([book_item, cd_item, chocolate_item])
      expect(order.total_tax).to eq(1.50)
    end
  end

  describe '#total_amount' do
    it 'calculates total amount including tax' do
      line_item1 = LineItem.new(product: book, quantity: 1)
      line_item2 = LineItem.new(product: music_cd, quantity: 1)
      line_item3 = LineItem.new(product: chocolate_bar, quantity: 1)

      order = Order.new([line_item1, line_item2, line_item3])
      expect(order.total_amount).to be_within(0.01).of(29.83)
    end

    it 'calculates total for imported items' do
      line_item1 = LineItem.new(product: imported_chocolates, quantity: 1)
      line_item2 = LineItem.new(product: imported_perfume, quantity: 1)

      order = Order.new([line_item1, line_item2])
      expect(order.total_amount).to eq(65.15)
    end

    it 'returns 0 for empty order' do
      order = Order.new([])
      expect(order.total_amount).to eq(0)
    end

    it 'handles multiple quantities' do
      line_item = LineItem.new(product: book, quantity: 5)
      order = Order.new([line_item])
      expect(order.total_amount).to eq(62.45)
    end
  end

  describe '#receipt' do
    it 'prints formatted receipt' do
      line_item1 = LineItem.new(product: book, quantity: 2)
      line_item2 = LineItem.new(product: music_cd, quantity: 1)

      order = Order.new([line_item1, line_item2])

      output = StringIO.new
      allow($stdout).to receive(:puts) { |msg| output.puts(msg) }

      order.receipt

      output.rewind
      lines = output.read.split("\n")

      expect(lines[0]).to eq('2 book: 24.98')
      expect(lines[1]).to eq('1 music CD: 16.49')
      expect(lines[2]).to eq('Sales Taxes: 1.50')
      expect(lines[3]).to eq('Total: 41.47')
    end

    it 'prints receipt for imported items' do
      line_item1 = LineItem.new(product: imported_chocolates, quantity: 1)
      line_item2 = LineItem.new(product: imported_perfume, quantity: 1)

      order = Order.new([line_item1, line_item2])

      output = StringIO.new
      allow($stdout).to receive(:puts) { |msg| output.puts(msg) }

      order.receipt

      output.rewind
      lines = output.read.split("\n")

      expect(lines[0]).to eq('1 imported box of chocolates: 10.50')
      expect(lines[1]).to eq('1 imported bottle of perfume: 54.65')
      expect(lines[2]).to eq('Sales Taxes: 7.65')
      expect(lines[3]).to eq('Total: 65.15')
    end

    it 'formats decimals with 2 places' do
      product = Product.new(name: 'test', price: 10.00, imported: false)
      line_item = LineItem.new(product: product, quantity: 1)
      order = Order.new([line_item])

      output = StringIO.new
      allow($stdout).to receive(:puts) { |msg| output.puts(msg) }

      order.receipt

      output.rewind
      lines = output.read.split("\n")

      expect(lines[1]).to eq('Sales Taxes: 1.00')
      expect(lines[2]).to eq('Total: 11.00')
    end

    it 'handles empty order' do
      order = Order.new([])

      output = StringIO.new
      allow($stdout).to receive(:puts) { |msg| output.puts(msg) }

      order.receipt

      output.rewind
      lines = output.read.split("\n")

      expect(lines[0]).to eq('Sales Taxes: 0.00')
      expect(lines[1]).to eq('Total: 0.00')
    end
  end

  context 'integration scenarios' do
    it 'handles test case from problem statement 1' do
      book = Product.new(name: 'book', price: 12.49, imported: false)
      music_cd = Product.new(name: 'music CD', price: 14.99, imported: false)
      chocolate_bar = Product.new(name: 'chocolate bar', price: 0.85, imported: false)

      items = [
        LineItem.new(product: book, quantity: 2),
        LineItem.new(product: music_cd, quantity: 1),
        LineItem.new(product: chocolate_bar, quantity: 1)
      ]

      order = Order.new(items)
      expect(order.total_tax).to eq(1.50)
      expect(order.total_amount).to eq(42.32)
    end

    it 'handles test case from problem statement 2' do
      imported_chocolates = Product.new(name: 'box of chocolates', price: 10.00, imported: true)
      imported_perfume = Product.new(name: 'bottle of perfume', price: 47.50, imported: true)

      items = [
        LineItem.new(product: imported_chocolates, quantity: 1),
        LineItem.new(product: imported_perfume, quantity: 1)
      ]

      order = Order.new(items)
      expect(order.total_tax).to eq(7.65)
      expect(order.total_amount).to eq(65.15)
    end
  end
end
