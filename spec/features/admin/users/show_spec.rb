# frozen_string_literal: true

# spec/features/users/show_spec.rb
require 'rails_helper'

describe 'Admin User Show Page', type: :feature do
  describe 'As an admin' do
    context "When I visit '/admin/users/:id'" do
      before(:each) do
        @user1 = create(:user)
        @user2 = create(:user)
        @user3 = create(:admin)

        VCR.use_cassette('movie_details', serialize_with: :json, :allow_playback_repeats => true, match_requests_on: [:method, :path]) do
          @cocaine_bear = MovieFacade.new.movie_details(804150)

          @viewing_party1 = create(:viewing_party, movie_id: @cocaine_bear.id)
          ViewingPartyUser.create!(viewing_party_id: @viewing_party1.id, user_id: @user1.id, user_type: 1)
          ViewingPartyUser.create!(viewing_party_id: @viewing_party1.id, user_id: @user2.id, user_type: 0)

          login_as(@user3)
          visit admin_user_path(@user1)
        end
      end

      it "I see '<user name>'s Dashboard' at the top of the page" do
        VCR.use_cassette('movie_details', serialize_with: :json, :allow_playback_repeats => true, match_requests_on: [:method, :path]) do
          within 'h3#heading' do
            expect(page).to have_content("#{@user1.name}'s Dashboard")
            expect(page).to_not have_content(@user2.name)
          end
        end
      end

      it 'I see a button to Discover Movies, and when I click on it, I am redirected to the discover page' do
        VCR.use_cassette('movie_details', serialize_with: :json, :allow_playback_repeats => true, match_requests_on: [:method, :path]) do
          within '.button_to' do
            expect(page).to have_button('Discover Movies')

            click_button 'Discover Movies'
          end

          expect(current_path).to eq(user_discover_index_path)
        end
      end

      it 'I see a section that lists viewing parties the user is the host of' do
        VCR.use_cassette('movie_details', serialize_with: :json, :allow_playback_repeats => true, match_requests_on: [:method, :path]) do
          within 'section#viewing_parties' do
            expect(page).to have_content('Viewing Parties')

            within "section#viewing_party_#{@viewing_party1.id}" do
              expect(page).to have_css('img.movie_image')
              expect(page).to have_content(@cocaine_bear.title)
              expect(page).to have_content(@viewing_party1.event_datetime.strftime('%A, %B %d %Y %I:%M'))
              expect(page).to have_content('Hosting')

              within 'div#invitees' do
                expect(page).to have_content(@user2.name)
              end
            end
          end
        end
      end

      it 'I see a section that lists viewing parties the user is invited to' do
        VCR.use_cassette('movie_details', serialize_with: :json, :allow_playback_repeats => true, match_requests_on: [:method, :path]) do
          visit admin_user_path(@user2)

          within "section#viewing_party_#{@viewing_party1.id}" do
            expect(page).to have_css('img.movie_image')
            expect(page).to have_content(@cocaine_bear.title)
            expect(page).to have_content(@viewing_party1.event_datetime.strftime('%A, %B %d %Y %I:%M'))
            expect(page).to have_content('Invited')

            within 'div#host' do
              expect(page).to have_content(@user1.name)
            end
          end
        end
      end
    end
  end

  describe 'As an registered user' do
    context "When I visit '/admin/users/:id'" do
      before(:each) do
        @user1 = create(:user)
        @user2 = create(:user)
        @user3 = create(:admin)

        login_as(@user1)
      end

      it 'does not allow registerd users to see the admin user show page' do
        visit admin_user_path(@user1)

        expect(page).to have_content("You are not an authorized user")
        expect(current_path).to eq(root_path)
      end
    end
  end

  describe 'As a visitor' do
    context "When I visit '/admin/users/:id'" do
      before(:each) do
        @user1 = create(:user)
        @user2 = create(:user)
        @user3 = create(:admin)
      end

      it 'does not allow registerd users to see the admin user show page' do
        visit admin_user_path(@user1)

        expect(page).to have_content("You are not an authorized user")
        expect(current_path).to eq(root_path)
      end
    end
  end
end
