module AlienTranslations
  class GameService
    def initialize(word_repository:, scrambler:, validator:, hint_manager:)
      @word_repository = word_repository
      @scrambler       = scrambler
      @validator       = validator
      @hint_manager    = hint_manager
    end
  
    def generate_puzzle
      word     = @word_repository.fetch_random
      builder  = DefaultPuzzleBuilder.new
      director = PuzzleDirector.new(builder)
      director.construct(
        word: word,
        scrambler: @scrambler,
        hint_manager: @hint_manager
      )
    end
  
    def check_attempt(puzzle, attempt)
      @validator.valid?(attempt, puzzle.solution)
    end
  
    def get_hint(puzzle, attempts:)
      @hint_manager.hint_for(puzzle, attempts: attempts)
    end
  end
end