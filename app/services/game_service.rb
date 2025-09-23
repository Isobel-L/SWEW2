# app/services/game_service.rb (top-level class is fine)
class GameService
  def initialize(word_repository:, scrambler:, validator:, hint_manager:)
    @word_repository = word_repository
    @scrambler       = scrambler
    @validator       = validator
    @hint_manager    = hint_manager
  end

  def generate_puzzle
    word = @word_repository.fetch_random
    scrambled = @scrambler.scramble(word)
    Puzzle.new(solution: word, scrambled_word: scrambled, hint_manager: @hint_manager)
  end

  def check_attempt(puzzle, attempt)
    @validator.valid?(attempt, puzzle.solution)
  end

  def get_hint(puzzle, attempts:)
    @hint_manager.hint_for(puzzle, attempts: attempts)
  end
end
