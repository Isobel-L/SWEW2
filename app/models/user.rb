class User < ApplicationRecord
  has_many :high_scores, dependent: :destroy

  # Per-game high from the HighScore table (0 if none)
  def high_score_for(game_key)
    high_scores.find_by(game_key: game_key)&.score.to_i
  end

  # Total points = sum of all game highs for this user
  def total_points
    high_scores.sum(:score).to_i
  end

  def alien_points  = high_score_for('alien_translations')
  def blast_points  = high_score_for('blast_off')
end
