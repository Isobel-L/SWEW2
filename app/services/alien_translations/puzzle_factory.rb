module AlienTranslations
  class PuzzleFactory
    def initialize(builder: DefaultPuzzleBuilder.new, director: AlienTranslations::PuzzleDirector.new(DefaultPuzzleBuilder.new))
      @builder  = builder
      @director = AlienTranslations::PuzzleDirector.new(@builder)
    end

    def build(word:, scrambler:, hint_manager:, difficulty: :normal)
      @director.construct(
        word:         word,
        scrambler:    scrambler,
        hint_manager: hint_manager,
        difficulty:   difficulty
      )
    end
  end
end