# frozen_string_literal: true

#./app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User
            .find_by(email: params[:email])
            .try(:authenticate, params[:password])
    
    if user
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path
    else
      flash[:error] = "Incorrect email/password"
      redirect_to new_session_path
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:success] = 'You have been successfully logged out'
    redirect_to root_path
  end
end