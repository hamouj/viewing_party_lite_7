# frozen_string_literal: true

require 'rails_helper'

describe 'Register Page', type: :feature do
  describe 'As a user,' do
    before(:each) do
      @user1 = create(:user)
    end

    context "when I visit the root path ('/')," do
      it 'I click a button to register a new user and I am taken to a registry form' do
        visit root_path

        # within 'section#existing_users' do
        #   expect(page).to have_content(@user1.email)
        # end

        within 'nav#create_new_user' do
          click_button 'Register as a User'
        end
        
        expect(current_path).to eq(register_path)
      end
    end

    context " when I visit the register path ('/register')" do
      before(:each) do
        @user2 = create(:user)

        visit register_path
      end

      it "there's a form where I can register my name, a unique email, password with confirmation and a button to submit" do
        within('section#user_registration') do
          expect(page).to have_content('Register A New User')

          within('div#registration_form') do
            expect(page).to have_field(:name)
            expect(page).to have_field(:email)
            expect(page).to have_field(:password)
            expect(page).to have_field(:password_confirmation)
            expect(page).to have_button('Create New User')
          end
        end
      end

      it 'I leave some or all fields empty and am redirected back to the page with an error message' do
        within('div#registration_form') do
          fill_in 'Name:', with: @user2.name
          fill_in 'E-mail:', with: ''
          fill_in 'Password:', with: ''
          fill_in 'Re-enter Password:', with: ''

          click_button 'Create New User'
        end

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Email can't be blank")
        expect(page).to have_content("Password can't be blank")

        within('div#registration_form') do
          fill_in 'Name:', with: ''
          fill_in 'E-mail:', with: ''
          fill_in 'Password:', with: ''
          fill_in 'Re-enter Password:', with: ''

          click_button 'Create New User'
        end

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Email can't be blank")
      end

      it 'I submit an email that already exists and am redirected back to the page with an error message' do
        email = 'Antonio.K.Hunt@gmail.com'
        password = 'password'

        within('div#registration_form') do
          fill_in 'Name:', with: 'Antonio'
          fill_in 'E-mail:', with: email
          fill_in 'Password:', with: password
          fill_in 'Re-enter Password:', with: password

          click_button 'Create New User'
        end

        visit register_path

        within('div#registration_form') do
          fill_in 'Name:', with: 'Toni'
          fill_in 'E-mail:', with: email
          fill_in 'Password:', with: password
          fill_in 'Re-enter Password:', with: password

          click_button 'Create New User'
        end

        expect(current_path).to eq(register_path)
        expect(page).to have_content('Email has already been taken')
      end

      it "I fill in the form with password and password_confirmation that do not match" do
        email = 'Antonio.K.Hunt@gmail.com'

        within('div#registration_form') do
          fill_in 'Name:', with: 'Antonio'
          fill_in 'E-mail:', with: email
          fill_in 'Password:', with: 'password'
          fill_in 'Re-enter Password:', with: 'PAssWord'

          click_button 'Create New User'
        end
        
        expect(current_path).to eq(register_path)
        expect(page).to have_content("Password confirmation doesn't match Password")
      end

      it "I fill in the form with password but don't fill out the password_confirmation" do
        email = 'Antonio.K.Hunt@gmail.com'

        within('div#registration_form') do
          fill_in 'Name:', with: 'Antonio'
          fill_in 'E-mail:', with: email
          fill_in 'Password:', with: 'password'

          click_button 'Create New User'
        end
        
        expect(current_path).to eq(register_path)
        expect(page).to have_content("Password confirmation doesn't match Password")
      end

      it "I submit valid information, I am taken to the dashboard page ('/users/:id') for the new user" do
        email = 'Antonio.K.Hunt@gmail.com'
        password = 'password'

        within('div#registration_form') do
          fill_in 'Name:', with: 'Antonio'
          fill_in 'E-mail:', with: email
          fill_in 'Password:', with: password
          fill_in 'Re-enter Password:', with: password

          click_button 'Create New User'
        end

        new_user = User.last

        expect(current_path).to eq(user_path(new_user.id))
        expect(page).to have_content('User Created')
      end
    end
  end
end
