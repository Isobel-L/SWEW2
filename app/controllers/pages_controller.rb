class PagesController < ApplicationController
  before_action :set_user

  def home
    # shows current profile info
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
    @user = User.first
  end

  def user_params
    params.require(:user).permit(:name, :bio, :avatar)
  end
end
