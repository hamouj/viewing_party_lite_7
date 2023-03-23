# frozen_string_literal: true

# spec/features/users/discover/index_spec.rb
require 'rails_helper'

describe 'User Discover Page', type: :feature do
  describe 'As a user' do
    context "When I visit '/users/:id/discover'" do
      before(:each) do
        @user1 = create(:user)
      end

      it 'links to the page from the users show page' do
        visit user_path(@user1)

        click_button 'Discover Movies'

        expect(current_path).to eq(user_discover_index_path(@user1))
      end

      it 'has a button to discover top rated movies' do
        visit user_discover_index_path(@user1)

        within('form.button_to') do
          expect(page).to have_button('Find Top Rated Movies')

          VCR.use_cassette('top_rated_movies', serialize_with: :json, match_requests_on: [:method, :path]) do
            click_button 'Find Top Rated Movies'
          end
        end

        expect(current_path).to eq(user_movies_path(@user1))
      end

      it 'has a text field to enter keyword(s) to search by movie title' do
        visit user_discover_index_path(@user1)

        within('form#keyword_movie_search') do
          expect(page).to have_field(:keyword)
          expect(page).to have_button('Find Movies')

          VCR.use_cassette('keyword_movie_search', serialize_with: :json, match_requests_on: [:method, :path]) do
            fill_in :keyword, with: 'Bear'
            click_button 'Find Movies'
          end
        end

        expect(current_path).to eq(user_movies_path(@user1))
      end
    end
  end
end
