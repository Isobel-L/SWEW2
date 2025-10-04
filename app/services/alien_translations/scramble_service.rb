module AlienTranslations
  class ScrambleService
    DEFAULT_DIFFICULTY = :normal
    ALLOWED = %i[easy normal hard].freeze

    def initialize(strategies:, default: DEFAULT_DIFFICULTY)
      @strategies = strategies.transform_keys(&:to_sym).freeze
      @current    = default.to_sym
      validate!
    end

    def set_difficulty(difficulty)
      diff = difficulty.to_sym
      raise ArgumentError, "Unknown difficulty: #{difficulty}" unless @strategies.key?(diff)
      @current = diff
    end

    def get_scrambler(difficulty = @current)
      @strategies.fetch(difficulty.to_sym)
    end

    def scramble(word, difficulty: @current)
      get_scrambler(difficulty).scramble(word)
    end

    def scramble_not_equal(word, difficulty: @current, max_tries: 5)
      tries = 0
      begin
        tries += 1
        out = scramble(word, difficulty: difficulty)
        return out if out != word || tries >= max_tries
      end while true
    end

    private

    def validate!
      missing = ALLOWED - @strategies.keys
      raise ArgumentError, "Missing strategies for: #{missing.join(', ')}" if missing.any?
    end
  end
end
