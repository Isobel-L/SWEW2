# frozen_string_literal: true
module AlienTranslations
  module Scramblers
    class PhoneticScrambler < Scrambler
      DIGRAPHS = %w[ch sh th ph wh qu].freeze

      def scramble(word)
        return word if word.length < 3

        # Step 1: split into chunks (letters or digraphs)
        chunks = split_into_chunks(word)

        # Step 2: shuffle chunks
        shuffled = chunks.shuffle

        # Step 3: join back into a string
        shuffled.join
      end

      private

      def split_into_chunks(word)
        chars = word.chars
        chunks = []
        i = 0
        while i < chars.length
          two = chars[i, 2].join
          if two && DIGRAPHS.include?(two.downcase)
            chunks << two
            i += 2
          else
            chunks << chars[i]
            i += 1
          end
        end
        chunks
      end
      
    end
  end
end
