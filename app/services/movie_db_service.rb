# frozen_string_literal: true

# app/services/movie_db_service.rb
class MovieDbService
  def top_rated_movies
    get_url('/3/movie/top_rated')
  end

  def movie_search(keyword)
    get_url("/3/search/movie?query=#{keyword}")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.params['api_key'] = ENV['movie_db_key']
      faraday.params['language'] = 'en-US'
    end
  end
end
