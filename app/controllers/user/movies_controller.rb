# frozen_string_literal: true

# app/controllers/user/movies_controller.rb
class User::MoviesController < ApplicationController
  def index
    @user = User.find(params[:user_id])

    @movies = if params[:keyword].present?
                MovieFacade.new.keyword_movie_search(params[:keyword])
              else
                MovieFacade.new.top_rated_movies
              end
  end
end
