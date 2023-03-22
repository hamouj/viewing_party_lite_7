require 'rails_helper'

describe 'Register Page', type: :feature do
  describe 'As a user,' do
    before(:each) do
      @user_1 = create(:user)
    end

    context "when I visit the root path ('/')," do
      it 'I click a button to register a new user and I am taken to a registry form' do
        visit root_path

        within 'section#user_interface' do
          click_button "Create A New User"
        end

        expect(current_path).to eq(register_path)
      end
    end

    context " when I visit the register path ('/register')" do
      xit '' do

      end
    end
  end
end