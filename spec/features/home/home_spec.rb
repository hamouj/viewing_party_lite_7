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

      it 'I click a button to register a new user and I am taken to a registry form' do
        within 'section#new_user' do
          click_button 'Create A New User'
        end

        expect(current_path).to eq(register_path)
      end

      it 'includes Title of Application, Button to Log In, a List of Existing Users which links to the users dashboard' do
        within 'header#title' do
          expect(page).to have_content('Viewing Party')
        end
        
        within 'section#existing_users' do
          expect(page).to have_link('Log In')

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

      it "I see a link 'Log In', and when I click on it, I'm taken to a Log In page ('/login') where I can input my unique email and password." do
        within 'section#existing_users' do
          click_link 'Log In'
        end

        expect(current_path).to eq(login_path)

        within('section#login_form') do
          expect(page).to have_field('E-mail')
          expect(page).to have_field('Password')
          expect(page).to have_button('Log In')
        end
      end

      it 'has a link to create a new user' do
        within('section#new_user') do
          expect(page).to have_button("Create A New User")

          click_button "Create A New User"
        end

        expect(current_path).to eq(register_path)
      end
    end
  end
end
