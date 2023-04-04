# frozen_string_literal: true

# spec/features/users/show_spec.rb
require 'rails_helper'

describe 'User Show Page', type: :feature do
  describe 'As a user' do
    context "When I visit '/dashboard'" do
      before(:each) do
        @user1 = create(:registered_user)
        @user2 = create(:registered_user)

        VCR.use_cassette('movie_details', serialize_with: :json, :allow_playback_repeats => true, match_requests_on: [:method, :path]) do
          @cocaine_bear = MovieFacade.new.movie_details(804150)

          @viewing_party1 = create(:viewing_party, movie_id: @cocaine_bear.id)
          ViewingPartyUser.create!(viewing_party_id: @viewing_party1.id, user_id: @user1.id, user_type: 1)
          ViewingPartyUser.create!(viewing_party_id: @viewing_party1.id, user_id: @user2.id, user_type: 0)

          visit root_path
          click_link 'Log In'

          fill_in :email, with: @user1.email
          fill_in :password, with: @user1.password
          click_button 'Log In'
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

      it 'I see a section that lists viewing parties I am the host of' do
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

      it 'I see a section that lists viewing parties I am invited to' do
        VCR.use_cassette('movie_details', serialize_with: :json, :allow_playback_repeats => true, match_requests_on: [:method, :path]) do
          visit root_path
          click_link 'Log Out'

          click_link 'Log In'
          fill_in :email, with: @user2.email
          fill_in :password, with: @user2.password
          click_button 'Log In'

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
end
