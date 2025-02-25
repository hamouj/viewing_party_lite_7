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
    @new_user = User.create(user_params)

    if @new_user.valid?
      if @new_user.save
        redirect_to user_path(@new_user.id)
        flash[:success] = 'User Created'
      end
    else
      redirect_to register_path
      flash[:errors] = @new_user.errors.full_messages.join(', ')
    end
  end

  private

  def user_params
    params.permit(
      :name,
      :email
    )
  end
end
