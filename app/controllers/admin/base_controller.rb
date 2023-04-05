class Admin::BaseController < ApplicationController
  before_action :require_admin

  private
    def require_admin
      unless current_admin?
        redirect_to root_path
        flash[:error] = 'You are not an authorized user.'
      end
    end
end