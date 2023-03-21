# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
end
