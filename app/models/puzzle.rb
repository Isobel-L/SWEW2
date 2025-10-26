class Puzzle
  attr_reader :scrambled_word, :solution, :hint_manager

  def initialize(solution:, scrambled_word:, hint_manager:)
    @solution = solution
    @scrambled_word = scrambled_word
    @hint_manager = hint_manager
  end

  def solved?(attempt)
    attempt == solution
  end
end