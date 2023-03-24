# frozen_string_literal: true

require 'rails_helper'

describe "User's Movie Details Page", type: :feature do
  describe 'As a User' do
    context "When I visit '/users/:user_id/movies/:movie_id'," do
      before(:each) do
        @user1 = create(:user)

        VCR.use_cassette('keyword_movie_search', serialize_with: :json, match_requests_on: [:method, :path]) do
          visit user_discover_index(@user1)

          fill_in :keyword, with: 'Bear'
          click_button 'Find Movies'
          
        end
        visit user_movie_path(@user1, @movie_id)
      end

      it 'I see a button to create a viewing party and a button to return to the Discover Page' do
        VCR.use_cassette('top_rated_movies', serialize_with: :json, match_requests_on: [:method, :path]) do
          top_rated_movies = MovieFacade.new.top_rated_movies
    
          within('nav#viewing_party_options') do
            expect(page).to have_button('Discover Page')
            expect(page).to have_button("Create Viewing Party for #{@movie.title}")
          end
        end
      end
    end
  end
end
