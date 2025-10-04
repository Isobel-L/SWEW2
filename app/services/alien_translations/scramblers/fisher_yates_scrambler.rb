module AlienTranslations
  module Scramblers
    class FisherYatesScrambler < Scrambler
      def scramble(word) = word.chars.shuffle.join
    end
  end
end