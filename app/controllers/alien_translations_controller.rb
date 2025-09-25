class AlienTranslationsController < ApplicationController
  def alien_translation
    facade  = AlienTranslations::AlienTranslationsFacade.new(session: session)
    @puzzle = facade.start_new_puzzle!
    render :alien_translation
  end

  def hint
    solution  = session[:solution]
    scrambled = session[:scrambled]
    return redirect_to(alien_translation_path, alert: "No active puzzle.") if solution.blank? || scrambled.blank?

    store = ::AlienTranslations::Hints::SessionProgressStore.new(session)
    store.increment_stage!
    stage = store.stage

    hint_mgr = ::AlienTranslations::Hints::ProgressiveHintManager.new
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

    hint_mgr = ::AlienTranslations::Hints::ProgressiveHintManager.new
    @puzzle  = Puzzle.new(solution: solution, scrambled_word: scrambled, hint_manager: hint_mgr)

    session[:attempts] = session[:attempts].to_i + 1

    service = GameService.new(
      word_repository: ::Repositories::StaticWordRepository.new,
      scrambler: ::AlienTranslations::Scramblers::ShuffleScrambler.new,
      validator: ::AlienTranslations::Validators::ExactMatchValidator.new,
      hint_manager: hint_mgr
    )

    if service.check_attempt(@puzzle, params[:attempt])
      redirect_to alien_translation_path, notice: "Correct! The word was #{solution}."
    else
      flash.now[:alert] = "Try again!"
      @hint = ::AlienTranslations::Hints::SessionProgressStore.new(session).last_hint
      render :alien_translation, status: :unprocessable_entity
    end
  end
end
