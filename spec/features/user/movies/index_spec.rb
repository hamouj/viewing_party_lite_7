# frozen_string_literal: true

require 'rails_helper'

describe 'Movie Index Page', type: :feature do
  describe 'As a User' do
    context "When I visit '/dashboard/discover', I click on top movies" do
      before(:each) do
        @user1 = create(:registered_user)

        visit user_discover_index_path

        VCR.use_cassette('top_rated_movies', serialize_with: :json, match_requests_on: [:method, :path]) do
          click_button 'Find Top Rated Movies'
          @top_rated_movies = MovieFacade.new.top_rated_movies
        end
      end

      it 'I see a button to go back to the discover page' do
        within('form.button_to') do
          expect(page).to have_button('Discover Page')

          click_button 'Discover Page'
        end

        expect(current_path).to eq(user_discover_index_path)
      end

      it 'I see the titles as links and the vote averages of the top 20 rated movies' do
        within('table#movie_results') do
          expect(page).to have_css('tr.movie', count: 20)

          within(first('tr.movie')) do
            within('td.title') do
              expect(page).to have_link(@top_rated_movies.first.title)
            end

            within('td.vote_average') do
              expect(page).to have_content(@top_rated_movies.first.vote_average)
            end
          end
        end
      end
    end

    context "When I visit '/dashboard/discover', I type a keyword and click 'Search by Movie Title'" do
      before(:each) do
        @user1 = create(:registered_user)

        visit user_discover_index_path

        VCR.use_cassette('keyword_movie_search', serialize_with: :json, match_requests_on: [:method, :path]) do
          fill_in :keyword, with: 'bear'
          click_button 'Find Movies'
          @bear_movies = MovieFacade.new.keyword_movie_search('Bear')
        end
      end

      it 'I see the title and the vote average of movies that include the keyword in the title' do
        within('table#movie_results') do
          expect(page).to have_css('tr.movie', count: 20)

          within(first('tr.movie')) do
            within('td.title') do
              expect(page).to have_link(@bear_movies.first.title)
            end

            within('td.vote_average') do
              expect(page).to have_content(@bear_movies.first.vote_average)
            end
          end
        end
      end

      it "clicks on a movie title and is brought to that movie's detail page" do
        VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
          within(first('td.title')) do
            click_link @bear_movies.first.title
          end
        end

        expect(current_path).to eq(user_movie_path(@bear_movies.first.id))
      end
    end
  end
end
