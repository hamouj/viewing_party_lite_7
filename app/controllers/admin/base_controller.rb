class Admin::BaseController < ApplicationController
  before_action :require_admin

  private
    def require_admin
      render file: "./public/404.html" unless current_admin?
    end
end