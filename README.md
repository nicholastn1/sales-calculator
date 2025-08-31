# Sales Calculator Challenge

> A Ruby-based sales tax calculator that generates receipts with proper tax calculations for various product categories.

## Requirements

### Tax Rules

- **Basic Sales Tax**: 10% on all products
- **Exemptions**: Books, food, and medical products are exempt from basic sales tax
- **Import Duty**: 5% on all imported products (no exemptions)
- **Rounding**: All tax calculations rounded to the nearest 0.05

### Output Format

The receipt must include:

- Each item's name and final price (including applicable taxes)
- Total sales taxes paid
- Grand total of all items

## Examples

### Example 1: Basic Items

**Input:**

```
2 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85
```

**Output:**

```
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```

### Example 2: Imported Items

**Input:**

```
1 imported box of chocolates at 10.00
1 imported bottle of perfume at 47.50
```

**Output:**

```
1 imported box of chocolates: 10.50
1 imported bottle of perfume: 54.65
Sales Taxes: 7.65
Total: 65.15
```

### Example 3: Mixed Items

**Input:**

```
1 imported bottle of perfume at 27.99
1 bottle of perfume at 18.99
1 packet of headache pills at 9.75
3 imported boxes of chocolates at 11.25
```

**Output:**

```
1 imported bottle of perfume: 32.19
1 bottle of perfume: 20.89
1 packet of headache pills: 9.75
3 imported boxes of chocolates: 35.55
Sales Taxes: 7.90
Total: 98.38
```

## Project Structure

```
├── lib/
│   ├── product.rb              # Product data model
│   ├── line_item.rb            # Individual line item with quantity
│   ├── tax_calculator.rb       # Core tax calculation logic
│   ├── receipt.rb              # Receipt generation and formatting
├── bin/
│   └── demo                    # Demo script
├── Dockerfile
├── Gemfile
└── README.md
```

## Getting Started

### Prerequisites

- **Ruby**: 3.4.5
- **Docker** (optional)

### Installation

```bash
bundle install
```

### Usage

#### Run with Docker

```bash
docker build -t sales-calculator . && docker run sales-calculator
```

### Testing

```bash
bundle exec rspec --format documentation
```

## Dependencies

- **RSpec**: Testing framework
