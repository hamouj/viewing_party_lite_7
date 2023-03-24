# frozen_string_literal: true

# app/facades/movie_facade.rb
class MovieFacade
  def top_rated_movies
    service = MovieDbService.new

    json = service.top_rated_movies

    json[:results].map do |movie_data|
      Movie.new(movie_data)
    end.first(20)
  end

  def keyword_movie_search(keyword)
    service = MovieDbService.new

    json = service.movie_search(keyword)

    json[:results].map do |movie_data|
      Movie.new(movie_data)
    end.first(20)
  end

  def movie_details(id)
    service = MovieDbService.new

    MovieData.new((service.movie_details(id)))
  end
end
