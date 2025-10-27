class LeaderboardController < ApplicationController
  def index
    #Calculate total points and sort descending
  @users = User
    .left_joins(:high_scores)
    .select('users.*, COALESCE(SUM(high_scores.score), 0) AS points_sum')
    .group('users.id')
    .order('points_sum DESC, users.username ASC')   # highest first; tiebreaker by name
  end
end
