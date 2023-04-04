# frozen_string_literal: true

# app/controllers/user/movies_controller.rb
class User::MoviesController < ApplicationController
  def index
    @movies = if params[:keyword].present?
                MovieFacade.new.keyword_movie_search(params[:keyword])
              else
                MovieFacade.new.top_rated_movies
              end
  end

  def show
    @movie = MovieFacade.new.movie_details(params[:id])
  end
end
