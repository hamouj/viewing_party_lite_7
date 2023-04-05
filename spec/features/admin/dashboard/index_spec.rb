require 'rails_helper'

describe 'Admin Dashboard Page', type: :feature do
  describe 'As an Admin User' do
    context 'When I log in as an admin user' do
      before(:each) do
        @user1 = create(:admin)
        @user2 = create(:registered_user)
        @user3 = create(:registered_user)
      end

      it 'I am taken to my admin dashboard' do
        login_as(@user1)

        expect(current_path).to eq(admin_dashboard_index_path)
        expect(page).to have_content("Admin Dashboard")
      end

      it 'does not allow registered users to see the admin dashboard index' do
        login_as(@user2)

        visit admin_dashboard_index_path
        
        expect(page).to have_content("You are not an authorized user")
        expect(current_path).to eq(root_path)
      end

      it 'does not allow visitors to see the admin dashboard index' do
        visit admin_dashboard_index_path
        
        expect(page).to have_content("You are not an authorized user")
        expect(current_path).to eq(root_path)
      end

      it 'I see a list of all registered user email addresses' do
        login_as(@user1)

        expect(page).to have_link(@user2.email)
        expect(page).to have_link(@user3.email)
      end

      it "When I click on a registered user's email address, I am taken to the admin users dashboard" do
        login_as(@user1)

        click_link @user2.email

        expect(current_path).to eq(admin_user_path(@user2))
      end
    end
  end
end