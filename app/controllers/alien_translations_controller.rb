class AlienTranslationsController < ApplicationController
  def alien_translation
    repo      = ::Repositories::StaticWordRepository.new
    scrambler = ::Scramblers::ShuffleScrambler.new
    validator = ::Validators::ExactMatchValidator.new
    hint_mgr  = ::Hints::ProgressiveHintManager.new

    @service = GameService.new(
      word_repository: repo,
      scrambler: scrambler,
      validator: validator,
      hint_manager: hint_mgr
    )

    @puzzle = @service.generate_puzzle
    session[:solution]  = @puzzle.solution
    session[:scrambled] = @puzzle.scrambled_word

    session[:attempts] = 0
    Hints::SessionProgressStore.new(session).reset!

    render :alien_translation
  end

  def hint
    solution  = session[:solution]
    scrambled = session[:scrambled]
    return redirect_to(alien_translation_path, alert: "No active puzzle.") if solution.blank? || scrambled.blank?

    store = Hints::SessionProgressStore.new(session)
    store.increment_stage!
    stage = store.stage

    hint_mgr = ::Hints::ProgressiveHintManager.new
    @puzzle  = Puzzle.new(solution: solution, scrambled_word: scrambled, hint_manager: hint_mgr)
    @hint    = hint_mgr.hint_for(@puzzle, attempts: stage)

    store.last_hint = @hint

    respond_to do |format|
      format.turbo_stream
      format.html { render :alien_translation, status: :ok }
    end
  end

  def create
    solution  = session[:solution]
    scrambled = session[:scrambled]
    return redirect_to(alien_translation_path, alert: "No active puzzle.") if solution.blank? || scrambled.blank?

    hint_mgr = ::Hints::ProgressiveHintManager.new
    @puzzle  = Puzzle.new(solution: solution, scrambled_word: scrambled, hint_manager: hint_mgr)

    session[:attempts] = session[:attempts].to_i + 1

    service = GameService.new(
      word_repository: ::Repositories::StaticWordRepository.new,
      scrambler: ::Scramblers::ShuffleScrambler.new,
      validator: ::Validators::ExactMatchValidator.new,
      hint_manager: hint_mgr
    )

    if service.check_attempt(@puzzle, params[:attempt])
      redirect_to alien_translation_path, notice: "Correct! The word was #{solution}."
    else
      flash.now[:alert] = "Try again!"
      @hint = Hints::SessionProgressStore.new(session).last_hint
      render :alien_translation, status: :unprocessable_entity
    end
  end
end
