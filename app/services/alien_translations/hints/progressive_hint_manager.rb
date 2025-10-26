module AlienTranslations
  module Hints
    class ProgressiveHintManager < HintManager
      def hint_for(puzzle, attempts:)
        sol = puzzle.solution
        n = [[attempts, 0].max, [sol.length - 1, 0].max].min
        sol.chars.map.with_index { |ch, i| i < n ? ch : "_" }.join
      end
    end
  end
end