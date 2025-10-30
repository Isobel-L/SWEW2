module HighScores
  class DbStore
    def initialize(user:)
      @user = user or raise ArgumentError, "user required"
    end

    def best_score(game_key)
      HighScore.where(user_id: @user.id, game_key: game_key).maximum(:score).to_i
    end

    def record!(score:, game_key:)
      HighScore.update_for!(user: @user, game_key: game_key, score: score)
    end
  end
end
