class GamesController < ApplicationController
  def new
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
    session[:attempts]  = 0
  end

  def create
    solution  = session[:solution]
    scrambled = session[:scrambled]
    if solution.blank? || scrambled.blank?
      redirect_to new_game_path, alert: "Started a fresh puzzle." and return
    end

    repo      = ::Repositories::StaticWordRepository.new
    scrambler = ::Scramblers::ShuffleScrambler.new
    validator = ::Validators::ExactMatchValidator.new
    hint_mgr  = ::Hints::ProgressiveHintManager.new

    service = GameService.new(
      word_repository: repo,
      scrambler: scrambler,
      validator: validator,
      hint_manager: hint_mgr
    )

    attempts = session[:attempts].to_i + 1
    session[:attempts] = attempts

    puzzle   = Puzzle.new(solution: solution, scrambled_word: scrambled, hint_manager: hint_mgr)
    @puzzle  = puzzle

    if service.check_attempt(puzzle, params[:attempt])
      redirect_to new_game_path, notice: "Correct! The word was #{solution}."
    else
      @hint = service.get_hint(puzzle, attempts: attempts)
      flash.now[:alert] = "Try again! Hint: #{@hint}"
      render :new, status: :unprocessable_content
    end
  end
end
