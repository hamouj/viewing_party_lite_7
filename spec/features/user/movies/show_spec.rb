# frozen_string_literal: true

require 'rails_helper'

describe "User's Movie Details Page", type: :feature do
  describe 'As a User' do
    context "When I visit '/users/:user_id/movies/:movie_id'," do
      before(:each) do
        @user1 = create(:user)

        VCR.use_cassette('keyword_movie_search', serialize_with: :json, match_requests_on: [:method, :path]) do
          visit user_discover_index_path(@user1)

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
        VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
          @cocaine_bear = MovieFacade.new.movie_details(804150)

          within('nav#viewing_party_options') do
            click_button 'Create A Viewing Party for Cocaine Bear'
          end
          
          expect(current_path).to eq(new_user_movie_viewing_party_path(@user1.id, @cocaine_bear.id))
        end
      end

      it "has the movie's vote average, movie runtime, genres," do
        VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
          @cocaine_bear = MovieFacade.new.movie_details(804150)

          within('table#movie_details') do
            save_and_open_page
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
    end
  end
end
