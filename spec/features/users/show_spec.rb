# frozen_string_literal: true

# spec/features/users/show_spec.rb
require 'rails_helper'

describe 'As a user' do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
  end

  context "When I visit '/users/:id" do
    it "I see '<user name>'s Dashboard' at the top of the page" do
      visit user_path(@user1)

      expect(page).to have_content("#{@user1.name}'s Dashboard")
      expect(page).to_not have_content(@user2.name)
    end

    it 'I see a button to Discover Movies' do
      visit user_path(@user1)

      expect(page).to have_button('Discover Movies')
    end

    it 'I see a section that lists viewing parties' do
      visit user_path(@user1)

      within '#viewing_parties' do
        expect(page).to have_content('Viewing Parties')
      end
    end
  end
end
