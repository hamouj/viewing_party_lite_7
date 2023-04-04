# frozen_string_literal: true

require 'rails_helper'

describe "User's Movie Details Page", type: :feature do
  describe 'As a User' do
    context "When I visit '/users/:user_id/movies/:movie_id'," do
      before(:each) do
        @user1 = create(:registered_user)

        visit root_path
        click_link 'Log In'

        fill_in :email, with: @user1.email
        fill_in :password, with: @user1.password
        click_button 'Log In'

        VCR.use_cassette('keyword_movie_search', serialize_with: :json, match_requests_on: [:method, :path]) do
          visit user_discover_index_path

          fill_in :keyword, with: 'bear'
          click_button 'Find Movies'
        end

        VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
          click_link 'Cocaine Bear'
        end
      end

      it 'I see a button to create a viewing party and a button to return to the Discover Page' do
        within('nav#viewing_party_options') do
          expect(page).to have_button('Discover Page')
          expect(page).to have_button('Create A Viewing Party for Cocaine Bear')
        end
      end

      it "The 'Create A Viewing Party for Cocaine Bear' button takes the user to new viewing party page" do
        VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
          @cocaine_bear = MovieFacade.new.movie_details(804150)

          within('nav#viewing_party_options') do
            click_button 'Create A Viewing Party for Cocaine Bear'
          end

          expect(current_path).to eq(new_user_movie_viewing_party_path(@cocaine_bear.id))
        end
      end

      it "has the movie's vote average, movie runtime, genres," do
        VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
          @cocaine_bear = MovieFacade.new.movie_details(804150)

          within('table#movie_overview') do
            within('td#vote_average') do
              expect(page).to have_content("Vote: #{@cocaine_bear.vote_average}")
            end
            within('td#movie_runtime') do
              expect(page).to have_content("Runtime: #{@cocaine_bear.time_format}")
            end
            within('td#genres') do
              expect(page).to have_content("Genre: #{@cocaine_bear.genres.join(', ')}")
            end
          end
        end
      end

      it "has the movie's summary description, first 10 cast members, review count and review author info," do
        VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
          @cocaine_bear = MovieFacade.new.movie_details(804150)

          within('section#movie_details') do
            within('article#summary') do
              expect(page).to have_content('Summary')
              expect(page).to have_content(@cocaine_bear.summary)
            end

            within('article#cast') do
              expect(page).to have_css('tr#member_details', count: 10)
              within(first('tr#member_details')) do
                expect(page).to have_css('.name')
                expect(page).to have_css('.div')
                expect(page).to have_css('.character')
              end
            end
            within('article#review') do
              expect(page).to have_content("#{@cocaine_bear.reviews.count} Reviews")
              within('div#review_details') do
                expect(page).to have_selector('.author')
                expect(page).to have_selector('.rating')
                expect(page).to have_selector('.content')
              end
            end
          end
        end
      end
    end
  end
end
