class PagesController < ApplicationController
  def home
    @user = User.find_by(id: session[:user_id])
  end

  def account
    @user = User.find_by(id: session[:user_id])
  end

  def edit_account
    @user = User.find_by(id: session[:user_id])
  end

  def update_account
    @user = User.find_by(id: session[:user_id])
    if @user.update(user_params)
      redirect_to account_path, notice: "Profile updated successfully!"
    else
      render :edit_account, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :bio, :school, :avatar)
  end
end


