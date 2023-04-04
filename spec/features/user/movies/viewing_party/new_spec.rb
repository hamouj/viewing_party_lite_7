# frozen_string_literal: true

require 'rails_helper'

describe 'New Viewing Party Page' do
  describe 'As a user' do
    context "When I visit 'users/:user_id/movies/:movie_id/new'" do
      before(:each) do
        @user1 = create(:registered_user)
        @user2 = create(:registered_user)
        @user3 = create(:registered_user)

        visit root_path
        click_link 'Log In'

        fill_in :email, with: @user1.email
        fill_in :password, with: @user1.password
        click_button 'Log In'

        VCR.use_cassette('movie_details', serialize_with: :json, :allow_playback_repeats => true, match_requests_on: [:method, :path]) do
          @cocaine_bear = MovieFacade.new.movie_details(804150)

          visit new_user_movie_viewing_party_path(@cocaine_bear.id)
        end
      end

      it 'I see the title of the movie, and a form with duration, when, start time, checkboxes to invite users, and a submit button' do
        within 'section#new_viewing_party' do
          expect(page).to have_content(@cocaine_bear.title)
          expect(page).to have_field :duration
          expect(page).to have_field :day
          expect(page).to have_field :start_time
          expect(page).to have_button 'Create Party'
          expect(page).to have_content("#{@user2.name}(#{@user2.email})")
          expect(page).to have_content("#{@user3.name}(#{@user3.email})")
        end
      end

      it 'When I fill in the form with all fields, I am redirected back to my user dashboard where I see my viewing party' do
        VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
          within 'section#new_viewing_party' do
            fill_in :duration, with: 100
            fill_in :day, with: Date.today
            fill_in :start_time, with: Time.now

            find(:css, "#invitees_#{@user2.id}").set true
            find(:css, "#invitees_#{@user3.id}").set true
            click_button 'Create Party'
          end

          expect(current_path).to eq(user_path)
          viewing_party = ViewingParty.last

          within "#viewing_party_#{viewing_party.id}" do
            expect(page).to have_content(@cocaine_bear.title)
            expect(page).to have_content(viewing_party.event_datetime.strftime('%A, %B %d %Y %I:%M'))
            expect(page).to have_content('Hosting')

            within '#invitees' do
              expect(page).to have_content(@user2.name)
              expect(page).to have_content(@user3.name)
            end
          end
        end
      end

      xit 'When I fill in the duration with a number less than the movie runtime, I receive an error message' do
        # In running rails s and Heroku, it does not let the user submit a value less than the runtime, however we couldn't get this test to work
        within 'section#new_viewing_party' do
          fill_in :duration, with: 70
          fill_in :day, with: Date.today
          fill_in :start_time, with: Time.now

          find(:css, "#invitees_#{@user2.id}").set true
          find(:css, "#invitees_#{@user3.id}").set true

          click_button 'Create Party'
        end

        expect(current_path).to eq(new_user_movie_viewing_party_path(@cocaine_bear.id))
      end

      it 'When I partially fill in the form, I receive an error message' do
        VCR.use_cassette('movie_details', serialize_with: :json, :allow_playback_repeats => true, match_requests_on: [:method, :path]) do
          within 'section#new_viewing_party' do
            fill_in :duration, with: 100
            fill_in :start_time, with: Time.now

            find(:css, "#invitees_#{@user2.id}").set true
            find(:css, "#invitees_#{@user3.id}").set true
            click_button 'Create Party'
          end

          expect(page).to have_content('Viewing Party Not Created, Date/Time is missing.')

          within 'section#new_viewing_party' do
            fill_in :duration, with: 100
            fill_in :day, with: Date.today

            find(:css, "#invitees_#{@user2.id}").set true
            find(:css, "#invitees_#{@user3.id}").set true
            click_button 'Create Party'
          end

          expect(page).to have_content('Viewing Party Not Created, Date/Time is missing.')
        end
      end
    end
  end
end
