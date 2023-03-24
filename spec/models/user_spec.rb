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
  end

  describe 'class_methods' do
    describe '.all_except' do
      it 'lists all users, excluding a specified user' do
        user1 = create(:user)
        user2 = create(:user)
        user3 = create(:user)

        expect(User.all_except(user2)).to eq([user1, user3])

        user4 = create(:user)

        expect(User.all_except(user2)).to eq([user1, user3, user4])
      end
    end
  end
end
