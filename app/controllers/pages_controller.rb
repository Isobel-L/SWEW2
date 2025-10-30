class PagesController < ApplicationController
  def home
  @user = User.find_by(id: session[:user_id])

  return unless @user

  at = @user.high_scores.find_by(game_key: 'alien_translations')
  bl = @user.high_scores.find_by(game_key: 'blast_off')

  # use 0 when there’s no record yet
  @alien_high_score = at&.score.to_i
  @blast_high_score = bl&.score.to_i

  # competition rank: 1 + count of users strictly higher (ties share rank)
  @alien_rank = @alien_high_score.positive? \
    ? HighScore.where(game_key: 'alien_translations').where("score > ?", @alien_high_score).count + 1
    : nil

  @blast_rank = @blast_high_score.positive? \
    ? HighScore.where(game_key: 'blast_off').where("score > ?", @blast_high_score).count + 1
    : nil

  # TOTAL POINTS (raw sum) + class rank
  totals_by_user = HighScore.group(:user_id).sum(:score)
  @total_points  = totals_by_user[@user.id].to_i
  @total_rank    = @total_points.positive? ? (1 + totals_by_user.values.count { |t| t > @total_points }) : nil
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


