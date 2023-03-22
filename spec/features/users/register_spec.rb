require 'rails_helper'

describe 'Register Page', type: :feature do
  describe 'As a user,' do
    before(:each) do
      @user_1 = create(:user)
    end

    context "when I visit the root path ('/')," do
      it 'I click a button to register a new user and I am taken to a registry form' do
        visit root_path

        within 'section#existing_users' do
          expect(page).to have_content(@user_1.email)

          click_button "Create A New User"
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
          expect(page).to have_content("Register A New User")

          within('div#registration_form') do
            expect(page).to have_field("Name")
            expect(page).to have_field("E-mail")
            expect(page).to have_button("Create New User")
          end
        end
      end

      it 'they leave either or both fields empty and are redirected back to the page with an error message' do
        within('div#registration_form') do
          fill_in "Name:", with: "#{@user2.name}"
          fill_in "E-mail:", with: ""

          click_button "Create New User"
        end

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Name cannot be blank")
        expect(page).to have_content("Email cannot be blank")
      end

      xit "they submit valid information and are taken back dashboard page ('/users/:id') for the new user" do

      end
    end
  end
end