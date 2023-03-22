# frozen_string_literal: true

# spec/features/users/show_spec.rb
require 'rails_helper'

describe 'User Show Page', type: :feature do
  describe 'As a user' do
    context "When I visit '/users/:id'" do
      before(:each) do
        @user1 = create(:user)
        @user2 = create(:user)

        visit user_path(@user1)
      end

      it "I see '<user name>'s Dashboard' at the top of the page" do
        expect(page).to have_content("#{@user1.name}'s Dashboard")
        expect(page).to_not have_content(@user2.name)
      end

      it 'I see a button to Discover Movies' do
        expect(page).to have_button('Discover Movies')
      end

      it 'I see a section that lists viewing parties' do
        within '#viewing_parties' do
          expect(page).to have_content('Viewing Parties')
        end
      end

      it 'When I click on the Discover Movies button, I am redirected to a discover page' do
        click_button 'Discover Movies'

        expect(current_path).to eq(user_discover_index_path(@user1))
      end
    end
  end
end
