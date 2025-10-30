class LeaderboardController < ApplicationController
  def index
    # Calculate total points and sort descending
    @users = User.all.sort_by(&:total_points).reverse
  end
end
