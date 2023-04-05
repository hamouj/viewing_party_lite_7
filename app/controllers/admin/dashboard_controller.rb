class Admin::DashboardController < Admin::BaseController
  def index
    @users = User.registered_users
  end
end