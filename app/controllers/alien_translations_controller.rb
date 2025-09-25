class AlienTranslationsController < ApplicationController
  def alien_translation
    facade  = AlienTranslations::AlienTranslationsFacade.new(session: session)
    @puzzle = facade.start_new_puzzle!
    render :alien_translation
  end

  def hint
    return redirect_to(alien_translation_path, alert: "No active puzzle.") if session[:solution].blank? || session[:scrambled].blank?
    facade  = AlienTranslations::AlienTranslationsFacade.new(session: session)
    @hint   = facade.next_hint!
    @puzzle = facade.current_puzzle  
    respond_to do |format|
      format.turbo_stream
      format.html { render :alien_translation, status: :ok }
    end
  end

  def create
    return redirect_to(alien_translation_path, alert: "No active puzzle.") if session[:solution].blank? || session[:scrambled].blank?
    facade  = AlienTranslations::AlienTranslationsFacade.new(session: session)
    correct = facade.submit_guess!(params[:attempt])

    if correct
      redirect_to alien_translation_path, notice: "Correct! The word was #{session[:solution]}."
    else
      flash.now[:alert] = "Try again!"
      @puzzle = facade.current_puzzle
      @hint = facade.last_hint
      render :alien_translation, status: :unprocessable_entity
    end
  end
end
