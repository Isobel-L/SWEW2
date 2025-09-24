module Hints
  class ProgressStore
    def reset!
      raise NotImplementedError
    end
    def increment_stage!
      raise NotImplementedError
    end
    def stage
      raise NotImplementedError
    end
    def last_hint
      raise NotImplementedError
    end
    def last_hint=(value)
      raise NotImplementedError
    end
  end
end
