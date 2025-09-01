# Sales Tax Calculator

The application calculates sales taxes for a shopping basket and prints a detailed receipt according to the specified rules.

---

## Table of Contents

- [Sales Tax Calculator](#sales-tax-calculator)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Assumptions](#assumptions)
    - [Input Format Assumptions](#input-format-assumptions)
    - [Tax Exemption Assumptions](#tax-exemption-assumptions)
    - [Tax Calculation Assumptions](#tax-calculation-assumptions)
    - [Output Format Assumptions](#output-format-assumptions)
    - [Error Handling Assumptions](#error-handling-assumptions)
  - [Technical Decisions and Additional Features](#technical-decisions-and-additional-features)
    - [Configuration Management](#configuration-management)
    - [Comprehensive Test Suite](#comprehensive-test-suite)
    - [Object-Oriented Design Patterns](#object-oriented-design-patterns)
    - [Input Validation and Error Handling](#input-validation-and-error-handling)
    - [Containerization Support](#containerization-support)
    - [Professional Development Practices](#professional-development-practices)
    - [Mathematical Precision](#mathematical-precision)
    - [Extensibility Considerations](#extensibility-considerations)
  - [Design and Architecture](#design-and-architecture)
    - [Core Components](#core-components)
      - [Domain Models](#domain-models)
      - [Services](#services)
      - [Business Logic](#business-logic)
      - [Input/Output](#inputoutput)
    - [Architectural Patterns](#architectural-patterns)
    - [Data Flow](#data-flow)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [How to Run](#how-to-run)
    - [Running the Tests](#running-the-tests)
  - [Demonstration](#demonstration)
    - [Input 1](#input-1)
    - [Input 2](#input-2)
    - [Input 3](#input-3)

---

## Overview

The problem involves calculating two types of taxes on products:

1.  **Basic Sales Tax:** A 10% rate applicable to all goods, except for books, food, and medical products.
2.  **Import Duty:** An additional 5% tax on all imported goods, with no exemptions.

The rounding rule specifies that the tax amount must be rounded up to the nearest `0.05`.

The application expects a list of products inputted through stdin, processes each item to calculate the final price (including taxes), and displays a formatted receipt detailing the items, the total sales taxes, and the grand total.

---

## Assumptions

Based on the problem requirements and test cases, the following assumptions were made during implementation:

### Input Format Assumptions

- Each input line follows the exact format: `[quantity] [product_name] at [price]`
- Quantity is always a positive integer
- Price is always a positive decimal number
- The word "at" is always present and separates the product name from the price
- Product names can contain multiple words (e.g., "box of chocolates")
- Imported products are identified by the presence of the word "imported" anywhere in the product name
- Input is provided via stdin, with each product on a separate line
- An empty line signals the end of input

### Tax Exemption Assumptions

- Tax exemptions are determined by keyword matching against the product name
- The exempt keywords are configurable via YAML file (`config/product_categories.yml`)
- Current exempt keywords include: book, books, chocolate, chocolates, pills, medicine, headache
- Keyword matching is case-sensitive and uses substring matching (e.g., "chocolate bar" matches "chocolate")
- If a product name contains any exempt keyword, the entire product is exempt from basic sales tax

### Tax Calculation Assumptions

- Basic sales tax rate is 10% for non-exempt items
- Import duty rate is 5% for all imported items (no exemptions)
- Tax rounding follows the specified rule: round up to the nearest 0.05
- The rounding formula `(raw_tax * 20).ceil / 20.0` correctly implements "round up to nearest 0.05"
- Total calculations are performed on individual line items, then summed

### Output Format Assumptions

- Receipt format matches the provided examples exactly
- Prices are displayed with 2 decimal places
- Line items show: `[quantity] [display_name]: [total_with_tax]`
- For imported items, "imported" is prepended to the product name in the display
- Sales taxes and total are shown at the bottom of the receipt

### Error Handling Assumptions

- Invalid input lines are silently ignored (filtered out by `.compact`)
- The application expects well-formed input and does not provide detailed error messages
- Zero or negative quantities/prices are considered invalid and ignored

---

## Technical Decisions and Additional Features

Beyond the basic requirements, several technical decisions were made to enhance code quality, maintainability, and professional standards:

### Configuration Management

**Decision**: Externalized tax exemption rules to a YAML configuration file (`config/product_categories.yml`)
**Rationale**: Rather than hardcoding exempt keywords in the business logic, this approach allows for easy modification of tax rules without code changes, supporting different jurisdictions or rule changes over time.

### Comprehensive Test Suite

**Implementation**: 784+ lines of RSpec tests across 5 test files covering all components
**Coverage**:

- Unit tests for each class (`Product`, `LineItem`, `Order`, `TaxCalculator`, `InputParser`)
- Edge cases and boundary conditions
- Tax calculation accuracy with various scenarios
- Input parsing validation and error handling
- Integration testing through complete order processing

**Test Configuration**: Professional RSpec setup with:

- Randomized test execution order
- Monkey patching disabled for cleaner tests
- Performance profiling enabled
- Focused test execution support

### Object-Oriented Design Patterns

**Decision**: Implemented Domain-Driven Design principles with clear separation of concerns
**Components**:

- **Domain Models**: `Product` and `LineItem` represent core business entities
- **Services**: `TaxCalculator` provides stateless tax computation
- **Aggregates**: `Order` manages collections and orchestrates business operations
- **Utilities**: `InputParser` handles data transformation

### Input Validation and Error Handling

**Decision**: Robust input parsing with validation rather than assuming perfect input
**Features**:

- Comprehensive input validation with graceful error handling
- Support for complex product naming patterns
- Automatic detection of imported products

### Containerization Support

**Decision**: Included Docker configuration for consistent deployment
**Benefits**: Ensures consistent Ruby environment across different development and deployment scenarios

### Professional Development Practices

**Tooling**:

- Bundler for dependency management
- RSpec for testing framework
- YAML for configuration management
- Git with proper repository structure

**Code Quality**:

- Single Responsibility Principle adherence
- Composition over inheritance
- Immutable value objects where appropriate
- Clear method and class naming conventions

### Mathematical Precision

**Decision**: Implemented precise tax rounding using integer arithmetic
**Rationale**: Avoids floating-point precision errors common in financial calculations by using the mathematically correct rounding formula

### Extensibility Considerations

The architecture supports future enhancements such as:

- Additional tax types or rates
- Different rounding rules per jurisdiction
- Multiple input formats
- Different output formats (JSON, XML, etc.)
- Database persistence
- Multi-currency support

---

## Design and Architecture

This project follows an object-oriented architecture that adheres to the **Single Responsibility Principle (SRP)** and **Separation of Concerns** to promote clean, testable, and maintainable code.

### Core Components

The solution is organized into the following key components:

#### Domain Models

- **`Product`**: Represents an individual item with attributes like name, price, and import status. It encapsulates business logic for determining tax exemptions by checking against configurable keywords loaded from a YAML configuration file.
- **`LineItem`**: Represents a product with its quantity in an order. It handles the calculation of taxes and totals for a specific product-quantity combination and manages the display formatting.

#### Services

- **`TaxCalculator`**: A stateless service class responsible for calculating tax amounts based on product characteristics. It applies a 10% basic sales tax (with exemptions for books, food, and medical products) and a 5% import duty. The tax calculation includes proper rounding to the nearest 0.05 using the formula `(raw_tax * 20).ceil / 20.0`.

#### Business Logic

- **`Order`**: Acts as an aggregate root that manages a collection of line items. It coordinates the calculation of total taxes and amounts across all items and handles receipt generation and formatting.

#### Input/Output

- **`InputParser`**: A utility class responsible for parsing input strings into structured data. It extracts quantity, product name, price, and import status from text input using string manipulation and validation.

### Architectural Patterns

- **Composition over Inheritance**: The design uses composition (e.g., `Order` contains `LineItem` objects, `LineItem` contains a `Product`) rather than inheritance, making the system more flexible and easier to extend.

- **Configuration-Driven Exemptions**: Tax exemptions are defined in a YAML configuration file (`config/product_categories.yml`) rather than hardcoded, allowing for easy modification without code changes.

- **Single Responsibility**: Each class has a focused responsibility - `Product` for item data, `TaxCalculator` for tax logic, `Order` for order management, and `InputParser` for input processing.

### Data Flow

1. **Input Processing**: Raw text input is parsed by `InputParser` into structured data
2. **Object Creation**: `Product` and `LineItem` objects are instantiated from parsed data
3. **Order Assembly**: `LineItem` objects are collected into an `Order`
4. **Tax Calculation**: `TaxCalculator` computes taxes for each product
5. **Receipt Generation**: `Order` formats and displays the final receipt

This architecture ensures that business rules are isolated, components are loosely coupled, and the system remains testable and maintainable.

---

## Prerequisites

- Ruby 3.4.5
- Bundler

---

## Installation

1.  Clone the repository to your local machine:

    ```bash
    git clone [https://github.com/nicholastn1/sales-calculator.git](https://github.com/nicholastn1/sales-calculator.git)
    cd sales-calculator
    ```

2.  Install the dependencies (in this case, RSpec) using Bundler:
    ```bash
    bundle install
    ```

---

## How to Run

The run script, `bin/run.rb`, serves as the application's entry point. It expects a list of products separated by newlines.
You can use stdin to simulate the input file.

1. Run the program with the following command:

```bash
ruby bin/run.rb
```

And input the following:

```txt
2 book at 12.49
1 imported box of chocolates at 10.00
1 imported bottle of perfume at 27.99
3 imported boxes of chocolates at 11.25
```

2. Run the program with the following command:

```bash
echo "2 book at 12.49
1 imported box of chocolates at 10.00
1 imported bottle of perfume at 27.99
3 imported boxes of chocolates at 11.25" | ruby bin/run.rb
```

### Running the Tests

The project includes a comprehensive test suite using RSpec to ensure that each component functions as expected. To run the tests, execute:

```bash
bundle exec rspec
```

---

## Demonstration

### Input 1

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

### Input 2

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

### Input 3

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
