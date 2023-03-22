# frozen_string_literal: true

# app/controllers/users/discover_controller.rb
class User::DiscoverController < ApplicationController
  def index
    @user = User.find(params[:user_id])
  end
end
