# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @host_viewing_parties = ViewingParty.host_viewing_parties(@user)
    @invited_viewing_parties = ViewingParty.invited_viewing_parties(@user)
    @movies = MovieFacade.new.viewing_party_movies(ViewingParty.list_movie_ids(@user))
  end

  def new
  end

  def create
    @new_user = User.new(user_params)

    if @new_user.valid? && user_params[:password] == user_params[:password_confirmation]
      @new_user.save
      redirect_to user_path(@new_user.id)
      flash[:success] = "Welcome, #{@new_user.name}"
    elsif user_params[:password] != user_params[:password_confirmation]
      redirect_to register_path
      flash[:alert] = "Passwords have to match"
    else
      redirect_to register_path
      flash[:errors] = @new_user.errors.full_messages.join(', ')
    end
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
