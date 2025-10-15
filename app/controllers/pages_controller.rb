class PagesController < ApplicationController
  before_action :require_login
  before_action :set_user

  def home
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      redirect_to login_path, alert: "Log in first"
    end
  end

  def login
    redirect_to root_path if session[:user_id]
  end

  def profile
    # shows profile page
  end

  def account
    # account settings form
  end

  def update_account
    if @user.update(user_params)
      redirect_to root_path, notice: "Profile updated!"
    else
      render :account
    end
  end

  private

  def set_user
    @user = User.find_by(id: session[:user_id])
  end

  def require_login
    redirect_to login_path, alert: "Please log in first!" unless session[:user_id]
  end

  def user_params
    params.require(:user).permit(:name, :bio, :avatar)
  end
end
