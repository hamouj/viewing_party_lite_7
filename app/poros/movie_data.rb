# frozen_string_literal: true

# app/poros/movie_data.rb
class MovieData
  attr_reader :id,
              :title,
              :vote_average,
              :runtime,
              :genres,
              :summary,
              :cast,
              :total_reviews,
              :reviews,
              :image

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @vote_average = attributes[:vote_average]
    @runtime = attributes[:runtime]
    @genres = genre_names(attributes[:genres])
    @summary = attributes[:overview]
    @cast = cast_list(attributes[:credits][:cast])
    @total_reviews = attributes[:reviews][:total_results]
    @reviews = review_list(attributes[:reviews][:results])
    @image = "https://image.tmdb.org/t/p/w185#{attributes[:poster_path]}"
  end

  def genre_names(genres)
    genres.pluck(:name)
  end

  def cast_list(list)
    list.first(10).map do |member|
      Cast.new(member)
    end
  end

  def review_list(list)
    list.map do |member|
      Review.new(member)
    end
  end
end
