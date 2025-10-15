# Creates controller logic for login and user sessions
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])

    # Sends user to home page on successful login, else show retry message
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out!"
  end
end
