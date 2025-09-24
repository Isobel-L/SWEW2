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
    session[:solution]    = @puzzle.solution
    session[:scrambled]   = @puzzle.scrambled_word
    session[:attempts]    = 0
    session[:hint_stage]  = 0
    session[:last_hint]   = nil
  end

def hint
  solution  = session[:solution]
  scrambled = session[:scrambled]
  return redirect_to(alien_translation_path, alert: "No active puzzle.") if solution.blank? || scrambled.blank?

  # advance stage per click
  session[:hint_stage] = session[:hint_stage].to_i + 1
  stage = session[:hint_stage]

  # build puzzle + manager
  hint_mgr = ::Hints::ProgressiveHintManager.new
  @puzzle  = Puzzle.new(solution: solution, scrambled_word: scrambled, hint_manager: hint_mgr)

  # ask manager first
  candidate = hint_mgr.respond_to?(:hint_for) ? hint_mgr.hint_for(@puzzle, attempts: stage) :
              hint_mgr.respond_to?(:next_hint) ? hint_mgr.next_hint(@puzzle) :
              nil

  prev = session[:last_hint].to_s

  # SAFETY NET: if manager returns nil or same as before, derive a stage-based hint
  # (reveal first N letters; tweak to your style if needed)
  if candidate.blank? || candidate == prev
    revealed = solution.to_s[0, stage]
    masked   = (solution.to_s[stage..] || "").gsub(/[A-Za-z]/, "•")
    candidate = "#{revealed}#{masked}"
  end

  @hint = candidate
  session[:last_hint] = @hint

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
      @hint = session[:last_hint] 
      render :alien_translation, status: :unprocessable_entity
    end
  end
end
