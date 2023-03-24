# frozen_string_literal: true

require 'rails_helper'

describe ViewingParty, type: :model do
  describe 'associations' do
    it { should have_many :viewing_party_users }
    it { should have_many(:users).through(:viewing_party_users) }
  end

  describe 'validations' do
    it { should validate_presence_of :event_datetime }
    it { should validate_presence_of :duration }
    it { should validate_numericality_of :duration }
  end

  describe 'class methods' do
    before(:each) do
      @user1 = create(:user)

      @viewing_party1 = create(:viewing_party, movie_id: 1)
      @viewing_party2 = create(:viewing_party, movie_id: 2)
      @viewing_party3 = create(:viewing_party, movie_id: 3)
      @viewing_party4 = create(:viewing_party, movie_id: 4)

      ViewingPartyUser.create!(user_id: @user1.id, viewing_party_id: @viewing_party1.id, user_type: 1)
      ViewingPartyUser.create!(user_id: @user1.id, viewing_party_id: @viewing_party2.id, user_type: 1)
      ViewingPartyUser.create!(user_id: @user1.id, viewing_party_id: @viewing_party4.id, user_type: 0)
    end

    describe 'host_viewing_parties()' do
      it 'lists all viewing parties a user is hosting' do
        expect(ViewingParty.host_viewing_parties(@user1)).to eq([@viewing_party1, @viewing_party2])

        ViewingPartyUser.create!(user_id: @user1.id, viewing_party_id: @viewing_party3.id, user_type: 1)

        expect(ViewingParty.host_viewing_parties(@user1)).to eq([@viewing_party1, @viewing_party2, @viewing_party3])
      end
    end

    describe 'invited_viewing_parties()' do
      it 'lists all viewing parties a user is hosting' do
        expect(ViewingParty.invited_viewing_parties(@user1)).to eq([@viewing_party4])

        ViewingPartyUser.create!(user_id: @user1.id, viewing_party_id: @viewing_party3.id, user_type: 0)

        expect(ViewingParty.invited_viewing_parties(@user1)).to match_array([@viewing_party4, @viewing_party3])
      end
    end

    describe 'list_movie_ids()' do
      it "lists the movie ids for all of a user's viewing parties" do
        expect(ViewingParty.list_movie_ids(@user1)).to eq([@viewing_party1.movie_id, @viewing_party2.movie_id, @viewing_party4.movie_id])

        ViewingPartyUser.create!(user_id: @user1.id, viewing_party_id: @viewing_party3.id, user_type: 0)

        expect(ViewingParty.list_movie_ids(@user1)).to eq([@viewing_party1.movie_id, @viewing_party2.movie_id, @viewing_party3.movie_id, @viewing_party4.movie_id])
      end
    end
  end

  describe 'instance methods' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)

      @viewing_party1 = create(:viewing_party)
      @viewing_party2 = create(:viewing_party)
      @viewing_party3 = create(:viewing_party)
      @viewing_party4 = create(:viewing_party)

      ViewingPartyUser.create!(user_id: @user1.id, viewing_party_id: @viewing_party1.id, user_type: 1)
      ViewingPartyUser.create!(user_id: @user2.id, viewing_party_id: @viewing_party1.id, user_type: 0)
      ViewingPartyUser.create!(user_id: @user3.id, viewing_party_id: @viewing_party1.id, user_type: 0)
    end

    describe 'list_invitees' do
      it 'lists all users who are invited to the viewing party' do
        expect(@viewing_party1.list_invitees).to eq([@user2, @user3])

        user4 = create(:user)
        ViewingPartyUser.create!(user_id: user4.id, viewing_party_id: @viewing_party1.id, user_type: 0)

        expect(@viewing_party1.list_invitees).to eq([@user2, @user3, user4])
      end
    end

    describe 'list_host' do
      it 'lists the host of the viewing party' do
        expect(@viewing_party1.list_host).to eq(@user1)

        ViewingPartyUser.create!(user_id: @user2.id, viewing_party_id: @viewing_party2.id, user_type: 1)

        expect(@viewing_party2.list_host).to eq(@user2)
      end
    end
  end
end
