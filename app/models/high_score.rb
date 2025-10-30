class HighScore < ApplicationRecord
  belongs_to :user

  validates :game_key, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0 }

  # Upsert: keep the higher of existing vs. new score
  def self.update_for!(user:, game_key:, score:)
    return unless user && game_key.present?

    hs = find_or_initialize_by(user: user, game_key: game_key)
    new_score = score.to_i
    hs.score = [hs.score.to_i, new_score].max
    hs.save! if hs.changed?
    hs
  end
end
