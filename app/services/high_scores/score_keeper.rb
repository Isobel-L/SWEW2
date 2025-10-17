module HighScores
  class ScoreKeeper
    def initialize(session:, cookies:)
      @session = session
      @store   = HighScores::FileBackedStore.new(session: session, cookies: cookies)
    end

    def run
      @session[:run_score].to_i
    end

    def last
      @session[:last_score]
    end

    def best
      @store.best_score
    end

    def reset_run!
      @session[:run_score] = 0
    end

    def apply_correct!(difficulty:, attempts:, hints:)
      gained = word_score(difficulty, attempts, hints)
      @session[:last_score] = gained
      @session[:run_score]  = run + gained
      best = @store.record!(@session[:run_score].to_i)
      { last: gained, run: @session[:run_score].to_i, best: best }
    end

    private

    def word_score(difficulty, attempts, hints)
      base =
        case difficulty
        when :easy   then 500
        when :normal then 1000
        when :hard   then 1500
        else               750
        end
      attempt_penalty = [attempts - 1, 0].max * 150
      raw    = [base - attempt_penalty, 0].max
      factor = (0.4 ** hints.to_i)
      (raw * factor).floor
    end
  end
end
