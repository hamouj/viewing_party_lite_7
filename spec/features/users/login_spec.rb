# frozen_string_literal: true

require 'rails_helper'

describe 'Login Page', type: :feature do
  describe 'As a user,' do
    context "when I visit the login page '/login'" do
      before(:each) do
        @user = create(:user, password: Faker::Internet.password)
        visit login_path
      end

      it "When I enter my unique email and correct password, I'm taken to my dashboard page" do
        within('section#login_form') do
          fill_in :email, with: @user.email
          fill_in :password, with: @user.password
          
          click_button "Log In"
        end
        
        expect(current_path).to_eq(user_discover_index(@user.id))
      end
    end
  end
end