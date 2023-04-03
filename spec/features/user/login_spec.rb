# frozen_string_literal: true

require 'rails_helper'

describe 'Log In Page', type: :feature do
  describe 'As a user,' do
    context 'When I visit the log in page' do
      before(:each) do
        @user1 = create(:user)

        visit login_path
      end

      it 'It has a form to input my unique email and password' do
        expect(page).to have_field(:email)
        expect(page).to have_field(:password)
        expect(page).to have_button('Log In')
      end

      it 'When I enter my unique email and correct password, I am taken to my dashboard page' do
        fill_in :email, with: @user1.email
        fill_in :password, with: @user1.password
        click_button 'Log In'

        expect(current_path).to eq(user_path(@user1))
        expect(page).to have_content("Welcome, #{@user1.name}!")
      end

      it "When I fail to fill in my correct credentials, I'm taken back to the Log In page" do
        fill_in :email, with: @user1.email
        fill_in :password, with: 'password'
        click_button 'Log In'

        expect(current_path).to eq(login_path)
        expect(page).to have_content('Incorrect email/password')

        fill_in :email, with: 'jasmine@gmail.com'
        fill_in :password, with: @user1.password
        click_button 'Log In'

        expect(current_path).to eq(login_path)
        expect(page).to have_content('Incorrect email/password')
      end
    end
  end
end