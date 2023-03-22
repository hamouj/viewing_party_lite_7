# frozen_string_literal: true

# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @users = User.all
  end
end
