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

      it 'has a link to log in' do
        within 'nav#login' do
          expect(page).to have_link('Log In')
        end
      end

      it "When I click on 'Log In', I'm taken to a login page" do
        within 'nav#login' do
          expect(page).to have_link('Log In')

          click_link 'Log In'
        end

        expect(current_path).to eq(new_session_path)
      end

      it 'includes Title of Application, Button to Create a New User, a List of Existing Users which links to the users dashboard' do
        within 'header#title' do
          expect(page).to have_content('Viewing Party')
        end

        within 'nav#create_new_user' do
          expect(page).to have_button('Register as a User')
        end
        
        # within 'section#existing_users' do
        #   within "div#user-#{@user1.id}" do
        #     expect(page).to have_link(@user1.email)
        #   end
        #   within "div#user-#{@user2.id}" do
        #     expect(page).to have_link(@user2.email)
        #   end
        #   within "div#user-#{@user3.id}" do
        #     expect(page).to have_link(@user3.email)
        #   end
        # end
      end
    end

    describe 'authorization' do
      context 'As a logged in user' do
        before(:each) do
          @user1 = create(:user)
          @user2 = create(:user)
          @user3 = create(:user)

          login_as(@user1)

          click_link 'Home'
        end

        it 'When I visit the landing page, I no longer see a link to log in or create an account' do
          expect(page).to_not have_link('Log In')
          expect(page).to_not have_link('Register as a User')
        end
        
        it "I see a link to log out" do
          expect(page).to have_link('Log Out')
        end

        it "When I click the link to Log Out, I'm taken to the landing page and see a Log In link" do
          click_link 'Log Out'

          expect(current_path).to eq(root_path)
          expect(page).to have_content('You have been successfully logged out')
          expect(page).to_not have_link('Log Out')
          expect(page).to have_link('Log In')
        end

        it 'There is a list of existing user emails' do
          within "div#user-#{@user1.id}" do
            expect(page).to have_content(@user1.email)
            expect(page).to_not have_link(@user1.email)
          end

          within "div#user-#{@user2.id}" do
            expect(page).to have_content(@user2.email)
            expect(page).to_not have_link(@user2.email)
          end

          within "div#user-#{@user3.id}" do
            expect(page).to have_content(@user3.email)
            expect(page).to_not have_link(@user3.email)
          end
        end
      end

      context 'as a visitor' do
        it 'I do not see the section of the page that lists existing users' do
          visit root_path

          expect(page).to_not have_content('Existing Users')
          expect(page).to_not have_css('existing_users')
        end

        it 'When I try to visit /dashboard, I remain on the langind page and see a message that I must be logged in' do
          visit root_path
          
          click_link 'Dashboard'

          expect(current_path).to eq(root_path)
          expect(page).to have_content('You must be logged in or registered to access the dashboard.')
        end
      end
    end
  end
end
