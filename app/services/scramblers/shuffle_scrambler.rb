module Scramblers
  class ShuffleScrambler < Scrambler
    def scramble(word) = word.chars.shuffle.join
  end
end