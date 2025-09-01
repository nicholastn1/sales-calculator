require 'spec_helper'
require_relative '../../lib/input_parser'

RSpec.describe InputParser do
  describe '.parse' do
    context 'with valid input' do
      it 'parses simple product' do
        result = InputParser.parse('1 book at 12.49')

        expect(result).to eq({
          quantity: 1,
          price: 12.49,
          imported: false,
          product_name: 'book'
        })
      end

      it 'parses imported product' do
        result = InputParser.parse('1 imported bottle of perfume at 47.50')

        expect(result).to eq({
          quantity: 1,
          price: 47.50,
          imported: true,
          product_name: 'bottle of perfume'
        })
      end

      it 'parses product with multiple quantities' do
        result = InputParser.parse('2 imported boxes of chocolates at 11.25')

        expect(result).to eq({
          quantity: 2,
          price: 11.25,
          imported: true,
          product_name: 'boxes of chocolates'
        })
      end

      it 'parses non-imported product with multiple words' do
        result = InputParser.parse('1 music CD at 14.99')

        expect(result).to eq({
          quantity: 1,
          price: 14.99,
          imported: false,
          product_name: 'music CD'
        })
      end

      it 'parses product with long name' do
        result = InputParser.parse('1 packet of headache pills at 9.75')

        expect(result).to eq({
          quantity: 1,
          price: 9.75,
          imported: false,
          product_name: 'packet of headache pills'
        })
      end

      it 'parses imported product with complex name' do
        result = InputParser.parse('3 imported luxury chocolate boxes at 25.00')

        expect(result).to eq({
          quantity: 3,
          price: 25.00,
          imported: true,
          product_name: 'luxury chocolate boxes'
        })
      end

      it 'handles decimal quantities as integers' do
        result = InputParser.parse('10 books at 12.49')

        expect(result).to eq({
          quantity: 10,
          price: 12.49,
          imported: false,
          product_name: 'books'
        })
      end

      it 'handles prices with no decimal places' do
        result = InputParser.parse('1 book at 10')

        expect(result).to eq({
          quantity: 1,
          price: 10.0,
          imported: false,
          product_name: 'book'
        })
      end
    end

    context 'with invalid input' do
      it 'returns nil for nil input' do
        expect(InputParser.parse(nil)).to be_nil
      end

      it 'returns nil for empty string' do
        expect(InputParser.parse('')).to be_nil
      end

      it 'returns nil for whitespace only' do
        expect(InputParser.parse('   ')).to be_nil
      end

      it 'returns nil for input without "at" keyword' do
        expect(InputParser.parse('1 book 12.49')).to be_nil
      end

      it 'returns nil for input with less than 4 words' do
        expect(InputParser.parse('1 at 12.49')).to be_nil
      end

      it 'returns nil for zero quantity' do
        expect(InputParser.parse('0 book at 12.49')).to be_nil
      end

      it 'returns nil for negative quantity' do
        expect(InputParser.parse('-1 book at 12.49')).to be_nil
      end

      it 'returns nil for non-numeric quantity' do
        expect(InputParser.parse('one book at 12.49')).to be_nil
      end

      it 'returns nil for zero price' do
        expect(InputParser.parse('1 book at 0')).to be_nil
      end

      it 'returns nil for negative price' do
        expect(InputParser.parse('1 book at -12.49')).to be_nil
      end

      it 'returns nil for non-numeric price' do
        expect(InputParser.parse('1 book at twelve')).to be_nil
      end

      it 'returns nil for missing product name' do
        expect(InputParser.parse('1 at 12.49')).to be_nil
      end

      it 'returns nil for imported without product name' do
        expect(InputParser.parse('1 imported at 12.49')).to be_nil
      end

      it 'returns nil for malformed input' do
        expect(InputParser.parse('book 1 at 12.49')).to be_nil
      end

      it 'returns nil for input with only spaces as product name' do
        expect(InputParser.parse('1    at 12.49')).to be_nil
      end
    end

    context 'edge cases' do
      it 'handles multiple spaces between words' do
        result = InputParser.parse('1   book   at   12.49')

        expect(result).to eq({
          quantity: 1,
          price: 12.49,
          imported: false,
          product_name: 'book'
        })
      end

      it 'handles imported in middle of product name' do
        result = InputParser.parse('1 imported bottle of imported perfume at 47.50')

        expect(result).to eq({
          quantity: 1,
          price: 47.50,
          imported: true,
          product_name: 'bottle of imported perfume'
        })
      end

      it 'handles "at" in product name' do
        result = InputParser.parse('1 chocolate at the station at 5.00')

        expect(result).to eq({
          quantity: 1,
          price: 5.00,
          imported: false,
          product_name: 'chocolate at the station'
        })
      end

      it 'handles very long product names' do
        long_name = 'very special limited edition collectors item with extra features'
        input = "1 #{long_name} at 999.99"
        result = InputParser.parse(input)

        expect(result).to eq({
          quantity: 1,
          price: 999.99,
          imported: false,
          product_name: long_name
        })
      end

      it 'handles large quantities' do
        result = InputParser.parse('9999 books at 12.49')

        expect(result).to eq({
          quantity: 9999,
          price: 12.49,
          imported: false,
          product_name: 'books'
        })
      end

      it 'handles large prices' do
        result = InputParser.parse('1 luxury item at 999999.99')

        expect(result).to eq({
          quantity: 1,
          price: 999999.99,
          imported: false,
          product_name: 'luxury item'
        })
      end

      it 'handles decimal with many places' do
        result = InputParser.parse('1 item at 12.999999')

        expect(result).to eq({
          quantity: 1,
          price: 12.999999,
          imported: false,
          product_name: 'item'
        })
      end
    end
  end
end
