class AlienTranslationsController < ApplicationController
  before_action :build_facade

  ALLOWED_DIFFICULTIES = %i[easy normal hard].freeze

  def change_difficulty
    difficulty = normalised_difficulty(params[:difficulty]) || :normal
    session[:difficulty] = difficulty

    @puzzle = @facade.start_new_puzzle!(difficulty: difficulty)
    @hint   = nil

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "difficulty-buttons",
            partial: "alien_translations/difficulty_buttons",
            locals: { difficulty: difficulty }
          ),
          turbo_stream.replace(
            "game-container",
            partial: "alien_translations/game_content",
            locals: { puzzle: @puzzle, hint: @hint, difficulty: difficulty }
          )
        ]
      end
      format.html { redirect_to alien_translation_path }
    end
  end

  def alien_translation
    difficulty = normalised_difficulty(params[:difficulty]) || session[:difficulty] || :normal
    session[:difficulty] = difficulty

    session[:run_score] ||= 0
    @run_score  = session[:run_score].to_i
    @puzzle     = @facade.start_new_puzzle!(difficulty: difficulty)
    @best_score = score_keeper.best

    render :alien_translation
  end

  def hint
    return redirect_to(alien_translation_path, alert: "No active puzzle.") if inactive_puzzle?

    @hint   = @facade.next_hint!
    @puzzle = @facade.current_puzzle

    respond_to do |format|
      format.turbo_stream
      format.html { render :alien_translation, status: :ok }
    end
  end

  def create
    return redirect_to(alien_translation_path, alert: "No active puzzle.") if inactive_puzzle?

    correct = @facade.submit_guess!(params[:attempt])

    if correct
      diff     = (session[:difficulty] || :normal).to_sym
      attempts = session[:attempts].to_i
      hints    = @facade.hints_used.to_i

      scores   = score_keeper.apply_correct!(difficulty: diff, attempts: attempts, hints: hints)
      @best_score = scores[:best]
      @run_score  = scores[:run]
      @new_best   = scores[:best] == @run_score
      @hint       = nil
      @puzzle     = @facade.start_new_puzzle!(difficulty: diff)

      respond_to do |format|
        format.turbo_stream { render :create }
        format.html do
          redirect_to alien_translation_path,
                      notice: "Correct! +#{scores[:last]} points. Run #{@run_score}. Best #{@best_score}."
        end
      end
    else
      score_keeper.reset_run!
      @run_score  = 0
      @new_best   = false
      @puzzle     = @facade.current_puzzle
      @hint       = @facade.last_hint
      @best_score = score_keeper.best
      flash.now[:alert] = "Wrong! Run reset."

      respond_to do |format|
        format.turbo_stream { render :create }
        format.html { render :alien_translation, status: :unprocessable_entity }
      end
    end
  end

  private

  def build_facade
    @facade = AlienTranslations::AlienTranslationsFacade.new(session: session)
  end

  def inactive_puzzle?
    session[:solution].blank? || session[:scrambled].blank?
  end

  def normalised_difficulty(value)
    return nil if value.blank?
    sym = value.to_s.downcase.to_sym
    ALLOWED_DIFFICULTIES.include?(sym) ? sym : :normal
  end

  private
  def score_keeper
    @score_keeper ||= HighScores::ScoreKeeper.new(session: session, cookies: cookies)
  end
end
