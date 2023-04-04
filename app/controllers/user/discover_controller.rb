# frozen_string_literal: true

# app/controllers/users/discover_controller.rb
class User::DiscoverController < ApplicationController
  def index
    @user = User.find_by(id: session[:user_id])
  end
end
