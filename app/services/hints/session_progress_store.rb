module Hints
  class SessionProgressStore < ProgressStore
    DEFAULT_SCOPE = "alien_translation".freeze
    def initialize(session, scope: DEFAULT_SCOPE)
      @session = session
      @scope   = scope
      @session[@scope] ||= {}
    end
    def reset!
      bucket[:hint_stage] = 0
      bucket[:last_hint]  = nil
    end
    def increment_stage!
      bucket[:hint_stage] = stage + 1
    end
    def stage
      bucket[:hint_stage].to_i
    end
    def last_hint
      bucket[:last_hint]
    end
    def last_hint=(value)
      bucket[:last_hint] = value
    end
    private
    def bucket
      @session[@scope]
    end
  end
end
