# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def show
    @user = User.find_by(id: session[:user_id])

    if @user && @user.registered?
      @host_viewing_parties = ViewingParty.host_viewing_parties(@user)
      @invited_viewing_parties = ViewingParty.invited_viewing_parties(@user)
      @movies = MovieFacade.new.viewing_party_movies(ViewingParty.list_movie_ids(@user))
    else
      flash[:error] = 'You must be logged in or registered to access the dashboard.'
      redirect_to root_path
    end
  end

  def new
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    user[:role] = 1
    new_user = User.new(user)

    if new_user.save
      session[:user_id] = new_user.id
      redirect_to user_path
      flash[:success] = 'User Created'
    else
      redirect_to register_path
      flash[:errors] = new_user.errors.full_messages.join(', ')
    end
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :role
    )
  end
end
