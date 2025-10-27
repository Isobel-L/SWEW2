class User < ApplicationRecord
  has_secure_password
  has_many :high_scores, dependent: :destroy

  def high_score_for(game_key)
    high_scores.find_by(game_key: game_key)&.score || 0
  end

end
