class Admin::UsersController < Admin::BaseController
  def show
    @user = User.find(params[:id])
    @host_viewing_parties = ViewingParty.host_viewing_parties(@user)
    @invited_viewing_parties = ViewingParty.invited_viewing_parties(@user)
    @movies = MovieFacade.new.viewing_party_movies(ViewingParty.list_movie_ids(@user))
  end
end