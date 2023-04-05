# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  let(:maddie)  { User.create!(name: 'Maddie', email: 'maddie@gmail.com', password: 'password123', password_confirmation: 'password123') }

  describe 'associations' do
    it { should have_many :viewing_party_users }
    it { should have_many(:viewing_parties).through(:viewing_party_users) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password_digest}
    it { should have_secure_password }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(%w[default admin])}
  end

  describe 'attributes' do
    it 'has a password_digest attribute' do
      expect(maddie).to_not have_attribute(:password)
      expect(maddie.password_digest).to_not eq('password123')
    end
  end

  describe 'class_methods' do
    describe '.all_except' do
      it 'lists all users, excluding a specified user' do

        user1 = create(:user)
        user2 = create(:user)
        user3 = create(:user)

        expect(User.all_except(user2)).to match_array([maddie, user1, user3])

        user4 = create(:user)

        expect(User.all_except(user2)).to match_array([maddie, user1, user3, user4])
      end
    end
  end
end
