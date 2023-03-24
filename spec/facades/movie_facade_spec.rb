# frozen_string_literal: true

require 'rails_helper'

describe MovieFacade do
  it 'creates Movie poros for top_rated_movies' do
    VCR.use_cassette('top_rated_movies', serialize_with: :json, match_requests_on: [:method, :path]) do
      top_rated_movies = MovieFacade.new.top_rated_movies

      expect(top_rated_movies.first).to be_a Movie
    end
  end

  it 'creates Movie poros for keyword_movie_search' do
    VCR.use_cassette('keyword_movie_search', serialize_with: :json, match_requests_on: [:method, :path]) do
      bear_movies = MovieFacade.new.keyword_movie_search('bear')

      expect(bear_movies.first).to be_a Movie
    end
  end

  it 'creates MovieData poros for movie_details' do
    VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
      cocaine_bear = MovieFacade.new.movie_details(804150)

      expect(cocaine_bear).to be_a MovieData
    end
  end
end
