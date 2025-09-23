module Hints
  class HintManager
    def hint_for(_puzzle, attempts:)
      raise NotImplementedError
    end
  end
end