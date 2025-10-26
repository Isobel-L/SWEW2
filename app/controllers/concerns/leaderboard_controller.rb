class LeaderboardController < ApplicationController
  def index
    #Calculate total points and sort descending
    @users = User.select("id, username, (alien_points + blastoff_points) AS total_points")
                 .order("total_points DESC")
  end
end
