class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create], raise: false

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to account_path, notice: "Welcome, #{@user.name || @user.username}!"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :username, :school, :bio, :avatar,
      :password, :password_confirmation
    )
  end
end
