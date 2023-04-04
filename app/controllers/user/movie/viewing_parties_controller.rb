# frozen_string_literal: true

# app/controllers/user/viewing_parties_controller.rb
class User::Movie::ViewingPartiesController < ApplicationController
  def new
    @user = User.find_by(id: session[:user_id])
    @movie = MovieFacade.new.movie_details(params[:movie_id])
    @users = User.all_except(@user)
  end

  def create
    user = User.find_by(id: session[:user_id])

    if params[:day].empty? || params[:start_time].empty?
      flash[:notice] = 'Viewing Party Not Created, Date/Time is missing.'
      redirect_to new_user_movie_viewing_party_path(params[:movie_id])
    else
      new_viewing_party = ViewingParty.create(viewing_party_params) do |viewing_party|
        viewing_party.event_datetime = make_datetime
      end

      if new_viewing_party.save
        ViewingPartyUser.create(user_id: session[:user_id], viewing_party_id: new_viewing_party.id, user_type: 1)

        if params[:invitees].present?
          params[:invitees].each do |invitee|
            ViewingPartyUser.create(user_id: invitee, viewing_party_id: new_viewing_party.id, user_type: 0)
          end
        end

        redirect_to "/dashboard?movie_id=#{params[:movie_id]}"
      else
        redirect_to new_user_movie_viewing_party_path(params[:movie_id])
        flash[:errors] = new_viewing_party.errors.full_messages.join(', ')
      end
    end
  end

  private

  def viewing_party_params
    params.permit(:event_datetime, :duration, :movie_id)
  end

  def make_datetime
    date = params[:day].to_date
    time = params[:start_time].to_time
    DateTime.new(date.year, date.month, date.day, time.hour, time.min)
  end
end
