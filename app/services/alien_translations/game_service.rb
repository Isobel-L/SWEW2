module AlienTranslations
  class GameService
    def initialize(word_repository:, validator:, hint_manager:, scrambler: nil, scramble_service: nil)
      @word_repository = word_repository
      @validator       = validator
      @hint_manager    = hint_manager

      @scramble_service =
        if scramble_service
          scramble_service
        elsif scrambler
          AlienTranslations::ScrambleService.new(
            strategies: { easy: scrambler, normal: scrambler, hard: scrambler },
            default: :normal
          )
        else
          raise ArgumentError, "Provide scrambler: or scramble_service:"
        end
    end

    def generate_puzzle(difficulty: :normal)
      word     = @word_repository.fetch_random
      factory  = AlienTranslations::PuzzleFactory.new

      factory.build(
        word:         word,
        scrambler:    @scramble_service,
        hint_manager: @hint_manager,
        difficulty:   difficulty
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
