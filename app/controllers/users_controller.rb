class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(uid: auth_hash[:uid], provider: auth_hash["provider"])

    if user # found in DB
      flash[:notice] = "Logged in as returning user #{user.username}"
    else # not in DB, attempt to create new user
      user = User.build_from_github(auth_hash)

      if user.save # user was able to save
        flash[:notice] = "Logged in a new user #{user.username}"
      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:error] = ["Could not create new user account username: [\"can't be blank\"]"]
        return redirect_to root_path
      end
    end

    # If we get here, we have a valid user instance
    session[:user_id] = user.id
    return redirect_to root_path
  end


  def logout
    if @login_user
      session[:user_id] = nil
      flash[:notice] = "Successfully logged out"

      redirect_to root_path
      return
    else
      flash[:warning] = "You were not logged in!"

      redirect_to root_path
      return
    end
  end
end
