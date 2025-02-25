# frozen_string_literal: true

require 'rails_helper'

describe MovieDbService do
  context 'instance methods' do
    context '#top_rated_movies' do
      it 'returns top movie data' do
        VCR.use_cassette('top_rated_movies', serialize_with: :json, match_requests_on: [:method, :path]) do
          top_rated_movie_data = MovieDbService.new.top_rated_movies

          expect(top_rated_movie_data).to be_a Hash
          expect(top_rated_movie_data[:results]).to be_an Array

          movie_data = top_rated_movie_data[:results].first

          expect(movie_data).to have_key :title
          expect(movie_data[:title]).to be_a String

          expect(movie_data).to have_key :vote_average
          expect(movie_data[:vote_average]).to be_a Float
        end
      end
    end

    context '#movie_search()' do
      it 'returns specific movies based on given keyword' do
        VCR.use_cassette('keyword_movie_search', serialize_with: :json, match_requests_on: [:method, :path]) do
          bear_movie_data = MovieDbService.new.movie_search('bear')

          expect(bear_movie_data).to be_a Hash
          expect(bear_movie_data[:results]).to be_an Array

          cocaine_bear_data = bear_movie_data[:results].first

          expect(cocaine_bear_data).to have_key :title
          expect(cocaine_bear_data[:title]).to be_a String

          expect(cocaine_bear_data).to have_key :vote_average
          expect(cocaine_bear_data[:vote_average]).to be_a Float
        end
      end
    end

    context '#movie_details()' do
      it 'returns a specific movies details' do
        VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
          cocaine_bear_data = MovieDbService.new.movie_details(804150)

          expect(cocaine_bear_data).to be_a Hash

          expect(cocaine_bear_data).to have_key :title
          expect(cocaine_bear_data[:title]).to be_a String

          expect(cocaine_bear_data).to have_key :vote_average
          expect(cocaine_bear_data[:vote_average]).to be_a Float

          expect(cocaine_bear_data).to have_key :runtime
          expect(cocaine_bear_data[:runtime]).to be_an Integer

          expect(cocaine_bear_data).to have_key :genres
          expect(cocaine_bear_data[:genres]).to be_an Array

          expect(cocaine_bear_data).to have_key :overview
          expect(cocaine_bear_data[:overview]).to be_a String

          expect(cocaine_bear_data[:credits]).to have_key :cast
          expect(cocaine_bear_data[:credits][:cast]).to be_an Array

          expect(cocaine_bear_data[:reviews]).to have_key :total_results
          expect(cocaine_bear_data[:reviews][:total_results]).to be_an Integer

          expect(cocaine_bear_data[:reviews]).to have_key :results
          expect(cocaine_bear_data[:reviews][:results]).to be_an Array
        end
      end
    end
  end
end
