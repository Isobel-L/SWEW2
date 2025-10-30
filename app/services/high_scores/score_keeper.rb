# app/services/high_scores/score_keeper.rb
module HighScores
  class ScoreKeeper
    DEFAULT_GAME_KEY = "alien_translations".freeze

    # Chooses DB store if a user is provided; falls back to file-backed store otherwise.
    def initialize(session:, cookies:, store: nil, user: nil, game_key: DEFAULT_GAME_KEY)
      @session  = session
      @game_key = game_key
      @store    = store ||
                  (user ? HighScores::DbStore.new(user: user) :
                          HighScores::FileBackedStore.new(session: session, cookies: cookies))
    end

    # Read API 

    def run
      @session[:run_score].to_i
    end

    def last
      @session[:last_score]
    end

    def best
      @store.best_score(@game_key)
    end

    # Write / mutate API
    def reset_run!
      @session[:run_score] = 0
    end

    # Apply scoring for a correct answer; persists to store as candidate for best.
    # Returns a hash: { run: Integer, best: Integer }
    def apply_correct!(difficulty:, attempts:, hints:)
      gained = word_score(difficulty: difficulty, attempts: attempts, hints: hints)
      @session[:run_score]  = run + gained
      @session[:last_score] = gained

      # Record the updated run as a high-score candidate, then fetch current best.
      @store.record!(score: run, game_key: @game_key)
      { run: run, best: best }
    end

    # Scoring logic
    def word_score(difficulty:, attempts:, hints:)
      base =
        case difficulty
        when :easy   then 500
        when :normal then 1000
        when :hard   then 1500
        else               750
        end

      attempt_penalty = [attempts.to_i - 1, 0].max * 150
      raw    = [base - attempt_penalty, 0].max
      factor = (0.4 ** hints.to_i)
      (raw * factor).floor
    end
  end
end
