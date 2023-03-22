# frozen_string_literal: true

require 'rails_helper'

describe 'Site Home Page:', type: :feature do
  describe 'As a user,' do
    context "when I visit the root path ('/')," do
      before(:each) do
        @user1 = create(:user)
        @user2 = create(:user)
        @user3 = create(:user)

        visit root_path
      end

      it 'has a Link to go back to the landing page' do
        within 'nav#navigation' do
          expect(page).to have_link('Home')
        end
      end

      it 'includes Title of Application, Button to Create a New User, a List of Existing Users which links to the users dashboard' do
        within 'header#title' do
          expect(page).to have_content('Viewing Party')
        end

        within 'section#existing_users' do
          expect(page).to have_button('Create A New User')

          within "div#user-#{@user1.id}" do
            expect(page).to have_link(@user1.email)
          end
          within "div#user-#{@user2.id}" do
            expect(page).to have_link(@user2.email)
          end
          within "div#user-#{@user3.id}" do
            expect(page).to have_link(@user3.email)
          end
        end
      end
    end
  end
end
