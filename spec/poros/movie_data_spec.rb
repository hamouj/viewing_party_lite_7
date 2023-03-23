# frozen_string_literal: true

require 'rails_helper'

describe MovieData do
  it 'has attributes' do
    VCR.use_cassette('movie_details', serialize_with: :json, match_requests_on: [:method, :path]) do
      cocaine_bear_data = MovieDbService.new.movie_details(804150)
      
      cocaine_bear = MovieData.new(cocaine_bear_data)
      
      expect(cocaine_bear.title).to eq("Cocaine Bear")
    end
  end
end
