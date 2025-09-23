class DefaultPuzzleBuilder < PuzzleBuilder
  def initialize
    reset
  end

  def reset
    @solution     = nil
    @scrambled    = nil
    @hint_manager = nil
  end

  def set_solution(word)
    @solution = word
    self
  end

  def set_scrambled(scrambled_word)
    @scrambled = scrambled_word
    self
  end

  def set_hint_manager(manager)
    @hint_manager = manager
    self
  end

  def puzzle
    raise "Missing solution"       unless @solution
    raise "Missing scrambled_word" unless @scrambled

    built = Puzzle.new(
      solution:      @solution,
      scrambled_word: @scrambled,
      hint_manager:  @hint_manager
    )
    reset
    built
  end
end
