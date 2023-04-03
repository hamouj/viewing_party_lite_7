# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe 'associations' do
    it { should have_many :viewing_party_users }
    it { should have_many(:viewing_parties).through(:viewing_party_users) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should have_secure_password }
    
    it 'secure_password' do
      user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq('password123')
    end
  end

  describe 'class_methods' do
    describe '.all_except' do
      it 'lists all users, excluding a specified user' do
        user1 = create(:user, password: Faker::Internet.password)
        user2 = create(:user, password: Faker::Internet.password)
        user3 = create(:user, password: Faker::Internet.password)

        expect(User.all_except(user2)).to eq([user1, user3])

        user4 = create(:user, password: Faker::Internet.password)

        expect(User.all_except(user2)).to eq([user1, user3, user4])
      end
    end
  end
end
