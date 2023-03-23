# frozen_string_literal: true

# app/poros/movie.rb
class Movie
  attr_reader :id,
              :title,
              :vote_average

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @vote_average = attributes[:vote_average]
  end
end
