class DefaultPuzzleBuilder < PuzzleBuilder
  def initialize
    reset
  end

  def reset
    @solution          = nil
    @scrambled         = nil
    @hint_manager      = nil
    @scrambler_service = nil
    @difficulty        = :normal
  end

  def set_solution(word)            ; @solution = word ; self end
  def set_scrambled(scrambled_word) ; @scrambled = scrambled_word ; self end
  def set_hint_manager(manager)     ; @hint_manager = manager ; self end

  def set_scrambler_service(service, difficulty: :normal)
    @scrambler_service = service
    @difficulty        = difficulty
    self
  end

  def puzzle
    raise "Missing solution"       unless @solution
    raise "Missing hint_manager"   unless @hint_manager
    @scrambled ||= @scrambler_service.scramble_not_equal(@solution, difficulty: @difficulty)

    built = Puzzle.new(
      solution:       @solution,
      scrambled_word: @scrambled,
      hint_manager:   @hint_manager
    )
    reset
    built
  end
end
