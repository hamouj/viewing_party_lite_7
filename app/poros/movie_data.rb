# frozen_string_literal: true

# app/poros/movie_data.rb
class MovieData
  attr_reader :title,
              :vote_average
              
  def initialize(attributes)
    @title = attributes[:title]  
    @vote_average = attributes[:vote_average]
    @hours = ( attributes[:runtime] / 60 )
    @minutes = ( attributes[:runtime] % 60 )
    @genres = genre_names(attributes[:genres])
    @summmary = attributes[:overview]
    @cast = cast_list(attributes[:credits][:cast])
    @total_reviews = attributes[:reviews][:total_results]
    @reviews = reviews(attributes[:reviews][:results])
  end
  
  def genre_names(genres)
    genres.map do |genre|
      genre[:name]
    end
  end

  def cast_list(list)
    list.first(10).map do |member|
      Cast.new(member)
    end
  end

  def reviews(list)
    list.map do |member|
      Review.new(member)
    end
  end
end
