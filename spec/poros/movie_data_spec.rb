# frozen_string_literal: true

require 'rails_helper'
require './app/poros/cast'
require './app/poros/review'

describe MovieData do
  it 'has attributes' do
    VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
      cocaine_bear_data = MovieDbService.new.movie_details(804150)

      cocaine_bear = MovieData.new(cocaine_bear_data)
      expect(cocaine_bear.id).to eq(804150)
      expect(cocaine_bear.image).to eq('https://image.tmdb.org/t/p/w185/gOnmaxHo0412UVr1QM5Nekv1xPi.jpg')
      expect(cocaine_bear.title).to eq('Cocaine Bear')
      expect(cocaine_bear.vote_average).to eq(6.514)
      expect(cocaine_bear.runtime).to eq(95)
      expect(cocaine_bear.genres).to eq(['Thriller', 'Comedy', 'Horror', 'Crime'])
      expect(cocaine_bear.summary).to eq('Inspired by a true story, an oddball group of cops, criminals, tourists and teens converge in a Georgia forest where a 500-pound black bear goes on a murderous rampage after unintentionally ingesting cocaine.')

      expect(cocaine_bear.cast).to be_an Array
      expect(cocaine_bear.cast.length).to eq(10)
      expect(cocaine_bear.cast.first.name).to eq('Keri Russell')
      expect(cocaine_bear.cast.first.character).to eq('Sari')

      expect(cocaine_bear.total_reviews).to eq(4)
      expect(cocaine_bear.reviews).to be_an Array
      expect(cocaine_bear.reviews.first.author).to eq('MSB')
      expect(cocaine_bear.reviews.first.rating).to eq(6.0)
      expect(cocaine_bear.reviews.first.content).to eq("FULL SPOILER-FREE REVIEW @ https://www.msbreviews.com/movie-reviews/cocaine-bear-review\r\n\r\n\"COCAINE BEAR offers what one expects from it: an absolutely INSANE bear wreaking gory, bloody havoc while also doing the stupidest things imaginable. A totally nonsensical yet extremely entertaining time where nothing else matters besides the bear who did cocaine.\"\r\n\r\nRating: B-")
    end
  end

  describe '#genre_names()' do
    it 'creates an array of genre names' do
      VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
        cocaine_bear_data = MovieDbService.new.movie_details(804150)

        cocaine_bear = MovieData.new(cocaine_bear_data)

        expect(cocaine_bear.genre_names(cocaine_bear_data[:genres])).to eq(['Thriller', 'Comedy', 'Horror', 'Crime'])
      end
    end
  end

  describe '#cast_list()' do
    it 'creates an array of Cast objects' do
      VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
        cocaine_bear_data = MovieDbService.new.movie_details(804150)

        cocaine_bear = MovieData.new(cocaine_bear_data)

        expect(cocaine_bear.cast_list(cocaine_bear_data[:credits][:cast])).to be_an Array
        expect(cocaine_bear.cast_list(cocaine_bear_data[:credits][:cast]).first).to be_a Cast
      end
    end
  end

  describe '#review_list()' do
    it 'creates an array of Review objects' do
      VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
        cocaine_bear_data = MovieDbService.new.movie_details(804150)

        cocaine_bear = MovieData.new(cocaine_bear_data)

        expect(cocaine_bear.review_list(cocaine_bear_data[:reviews][:results])).to be_an Array
        expect(cocaine_bear.review_list(cocaine_bear_data[:reviews][:results]).first).to be_a Review
      end
    end
  end

  describe 'time_format' do
    it 'creates an array of Review objects' do
      VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
        cocaine_bear_data = MovieDbService.new.movie_details(804150)

        cocaine_bear = MovieData.new(cocaine_bear_data)

        expect(cocaine_bear.time_format).to be_a String
      end
    end
  end
end
