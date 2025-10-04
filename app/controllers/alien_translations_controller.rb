class AlienTranslationsController < ApplicationController
  before_action :build_facade

  ALLOWED_DIFFICULTIES = %i[easy normal hard].freeze

  def alien_translation
    difficulty = normalised_difficulty(params[:difficulty]) || session[:difficulty] || :normal
    session[:difficulty] = difficulty

    @puzzle = @facade.start_new_puzzle!(difficulty: difficulty)
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
      redirect_to alien_translation_path, notice: "Correct! The word was #{session[:solution]}."
    else
      flash.now[:alert] = "Try again!"
      @puzzle = @facade.current_puzzle
      @hint   = @facade.last_hint
      render :alien_translation, status: :unprocessable_entity
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
end
