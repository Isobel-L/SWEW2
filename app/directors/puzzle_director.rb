class PuzzleDirector
  def initialize(builder)
    @builder = builder
  end

  def construct(word:, scrambler:, hint_manager:)
    @builder
      .set_solution(word)
      .set_scrambled(scrambler.scramble(word))
      .set_hint_manager(hint_manager)
      .puzzle
  end
end