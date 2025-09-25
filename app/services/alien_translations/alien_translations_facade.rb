module AlienTranslations
  class AlienTranslationsFacade
    def initialize(session:,
                   repo:        ::Repositories::StaticWordRepository.new,
                   scrambler:   ::AlienTranslations::Scramblers::ShuffleScrambler.new,
                   validator:   ::AlienTranslations::Validators::ExactMatchValidator.new,
                   hint_manager: ::AlienTranslations::Hints::ProgressiveHintManager.new)
      @session = session
      @service = GameService.new(
        word_repository: repo,
        scrambler:       scrambler,
        validator:       validator,
        hint_manager:    hint_manager
      )
      @store = ::AlienTranslations::Hints::SessionProgressStore.new(@session)
      @hint_manager = hint_manager
    end

    def start_new_puzzle!
      @store.reset!
      @session[:attempts] = 0

      puzzle = @service.generate_puzzle
      @session[:solution]  = puzzle.solution
      @session[:scrambled] = puzzle.scrambled_word
      puzzle
    end

    def current_puzzle
      Puzzle.new(
        solution:       @session[:solution],
        scrambled_word: @session[:scrambled],
        hint_manager:   @hint_manager
      )
    end

    def next_hint!
      @store.increment_stage!
      hint = @hint_manager.hint_for(current_puzzle, attempts: @store.stage)
      @store.last_hint = hint
      hint
    end

    def submit_guess!(attempt)
      @session[:attempts] = @session[:attempts].to_i + 1
      @service.check_attempt(current_puzzle, attempt)
    end

    def last_hint
      @store.last_hint
    end
  end
end
