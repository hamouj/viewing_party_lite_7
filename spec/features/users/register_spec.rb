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

        within 'section#existing_users' do
          expect(page).to have_content(@user1.email)

          click_button 'Create A New User'
        end

        expect(current_path).to eq(register_path)
      end
    end

    context " when I visit the register path ('/register')" do
      before(:each) do
        @user2 = create(:user)

        visit register_path
      end

      it "there's a form where the user can register name, a unique email, and submit" do
        within('section#user_registration') do
          expect(page).to have_content('Register A New User')

          within('div#registration_form') do
            expect(page).to have_field('Name')
            expect(page).to have_field('E-mail')
            expect(page).to have_button('Create New User')
          end
        end
      end

      it 'they leave either or both fields empty and are redirected back to the page with an error message' do
        within('div#registration_form') do
          fill_in 'Name:', with: @user2.name
          fill_in 'E-mail:', with: ''

          click_button 'Create New User'
        end

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Email can't be blank")

        within('div#registration_form') do
          fill_in 'Name:', with: ''
          fill_in 'E-mail:', with: ''

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

          click_button 'Create New User'
        end

        visit register_path

        within('div#registration_form') do
          fill_in 'Name:', with: 'Toni'
          fill_in 'E-mail:', with: email

          click_button 'Create New User'
        end

        save_and_open_page

        expect(current_path).to eq(register_path)
        expect(page).to have_content('Email has already been taken')
      end

      it "they submit valid information and are taken back dashboard page ('/users/:id') for the new user" do
        email = 'Antonio.K.Hunt@gmail.com'

        within('div#registration_form') do
          fill_in 'Name:', with: 'Antonio'
          fill_in 'E-mail:', with: email

          click_button 'Create New User'
        end

        new_user = User.find_by(email: email)

        expect(current_path).to eq(user_path(new_user.id))
        expect(page).to have_content('User Created')
      end
    end
  end
end
