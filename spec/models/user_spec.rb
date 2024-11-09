require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    before do
      @user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
    end

    it 'is valid with all required fields set' do
      expect(@user).to be_valid
    end

    it 'is not valid without a first name' do
      @user.first_name = nil
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("First name can't be blank")
    end

    it 'is not valid without a last name' do
      @user.last_name = nil
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("Last name can't be blank")
    end

    it 'is not valid without an email' do
      @user.email = nil
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it 'is not valid if passwords do not match' do
      @user.password_confirmation = 'different_password'
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'is not valid if email is not unique (case insensitive)' do
      @user.save!
      user2 = User.new(
        first_name: 'Jane',
        last_name: 'Smith',
        email: 'TEST@EXAMPLE.COM',
        password: 'password456',
        password_confirmation: 'password456'
      )
      expect(user2).not_to be_valid
      expect(user2.errors.full_messages).to include('Email has already been taken')
    end

    it 'is not valid if the password length is less than 8 characters' do
      @user.password = @user.password_confirmation = 'short'
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 8 characters)')
    end
  end

  describe '.authenticate_with_credentials' do
    before do
      @user = User.create(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
    end

    it 'returns the user when credentials are correct' do
      user = User.authenticate_with_credentials('test@example.com', 'password123')
      expect(user).to eq(@user)
    end

    it 'returns nil when credentials are incorrect' do
      user = User.authenticate_with_credentials('test@example.com', 'wrongpassword')
      expect(user).to be_nil
    end

    it 'authenticates successfully even if there are leading or trailing spaces in the email' do
      user = User.authenticate_with_credentials('  test@example.com  ', 'password123')
      expect(user).to eq(@user)
    end

    it 'authenticates successfully regardless of email case' do
      user = User.authenticate_with_credentials('TEST@EXAMPLE.COM', 'password123')
      expect(user).to eq(@user)
    end
  end
end
