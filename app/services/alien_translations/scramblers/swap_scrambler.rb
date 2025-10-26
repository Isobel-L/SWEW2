module AlienTranslations
  module Scramblers
    class SwapScrambler < Scrambler
      # Swaps two random letters in the word.
      def scramble(word)
        return word if word.length < 2

        i, j = (0...word.length).to_a.sample(2)
        chars = word.chars
        chars[i], chars[j] = chars[j], chars[i]
        chars.join
      end
    end
  end
end