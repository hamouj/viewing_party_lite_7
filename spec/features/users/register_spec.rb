# frozen_string_literal: true

require 'rails_helper'

describe 'Register Page', type: :feature do
  describe 'As a user,' do
    context " when I visit the register path ('/register')" do
      before(:each) do
        @user1 = create(:user)
        @fake_password = Faker::Internet.password
        
        visit register_path
      end

      it "there's a form where the user can register name, a unique email, valid password and submit" do
        within('section#user_registration') do
          expect(page).to have_content('Register A New User')

          within('div#registration_form') do
            expect(page).to have_field('Name')
            expect(page).to have_field('E-mail')
            expect(page).to have_field('Password')
            expect(page).to have_field('Confirm Password')
            expect(page).to have_button('Create New User')
          end
        end
      end

      it 'they leave email empty and are redirected back to the page with an error message' do
        within('div#registration_form') do
          fill_in 'Name:', with: 'Valid Name'
          fill_in 'E-mail:', with: ''
          fill_in 'Password:', with: @fake_password
          fill_in 'Confirm Password:', with: @fake_password

          click_button 'Create New User'
        end

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Email can't be blank")

        within('div#registration_form') do
          fill_in 'Name:', with: ''
          fill_in 'E-mail:', with: ''
          fill_in 'Password:', with: @fake_password
          fill_in 'Confirm Password:', with: @fake_password

          click_button 'Create New User'
        end

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Email can't be blank")
      end

      it 'they submit an email that already exists and are redirected back to the page with an error message' do
        email = 'Antonio.K.Hunt@gmail.com'

        within('div#registration_form') do
          fill_in 'Name:', with: 'Antonio'
          fill_in 'E-mail:', with: email
          fill_in 'Password:', with: @fake_password
          fill_in 'Confirm Password:', with: @fake_password

          click_button 'Create New User'
        end

        visit register_path

        within('div#registration_form') do
          fill_in 'Name:', with: 'Toni'
          fill_in 'E-mail:', with: email
          fill_in 'Password:', with: @fake_password
          fill_in 'Confirm Password:', with: @fake_password

          click_button 'Create New User'
        end

        expect(current_path).to eq(register_path)
        expect(page).to have_content('Email has already been taken')
      end

      it "they submit a confirmation password that doesnt match the password, they get an error, and are redirected back to the form" do
        within('div#registration_form') do
          fill_in 'Name:', with: 'Antonio'
          fill_in 'E-mail:', with: 'Antonio.K.Hunt@gmail.com'
          fill_in 'Password:', with: @fake_password
          fill_in 'Confirm Password:', with: @fake_password + "G"

          click_button 'Create New User'
        end
        
        expect(current_path).to eq(register_path)
        expect(page).to have_content("Passwords have to match")
      end

      it "they submit valid information and are taken back dashboard page ('/users/:id') for the new user" do
      
        within('div#registration_form') do
          fill_in 'Name:', with: 'Antonio'
          fill_in 'E-mail:', with: 'Antonio.K.Hunt@gmail.com'
          fill_in 'Password:', with: @fake_password
          fill_in 'Confirm Password:', with: @fake_password

          click_button 'Create New User'
        end

        new_user = User.last

        expect(current_path).to eq(user_path(new_user.id))
        expect(page).to have_content("Welcome, #{new_user.name}!")
      end
    end
  end
end
