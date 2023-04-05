class Admin::DashboardController < Admin::BaseController
  def index
    @users = User.default_users
  end
end