module AlienTranslations
  class PuzzleDirector
    def initialize(builder)
      @builder = builder
    end

    def construct(word:, scrambler:, hint_manager:, difficulty: :normal)
      scrambled =
        if scrambler.respond_to?(:scramble_not_equal)
          scrambler.scramble_not_equal(word, difficulty: difficulty)
        else
          s = scrambler.scramble(word)
          s == word ? fallback_shuffle(word) : s
        end

      @builder
        .set_solution(word)
        .set_scrambled(scrambled)
        .set_hint_manager(hint_manager)
        .puzzle
    end

    private

    def fallback_shuffle(word, max_tries: 5)
      tries = 0
      begin
        tries += 1
        out = word.chars.shuffle.join
        return out if out != word || tries >= max_tries
      end while true
    end
  end
end
