require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    before do
      @category = Category.create(name: "Test Category")
    end

    it 'is valid with all fields set' do
      product = Product.new(
        name: "Test Product",
        price_cents: 10000,  # Using price_cents to ensure compatibility with money-rails
        quantity: 5,
        category: @category
      )
      expect(product).to be_valid
    end

    it 'is not valid without a name' do
      product = Product.new(
        name: nil,
        price_cents: 10000,
        quantity: 5,
        category: @category
      )
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Name can't be blank")
    end

    it 'is not valid without a price' do
      product = Product.new(
        name: "Test Product",
        price_cents: nil,  # Using price_cents explicitly
        quantity: 5,
        category: @category
      )
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Price is not a number")
    end

    it 'is not valid without a quantity' do
      product = Product.new(
        name: "Test Product",
        price_cents: 10000,
        quantity: nil,
        category: @category
      )
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Quantity can't be blank")
    end

    it 'is not valid without a category' do
      product = Product.new(
        name: "Test Product",
        price_cents: 10000,
        quantity: 5,
        category: nil
      )
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Category can't be blank")
    end
  end
end
