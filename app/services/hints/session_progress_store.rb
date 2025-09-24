module Hints
  class SessionProgressStore < ProgressStore
    DEFAULT_SCOPE = "alien_translation".freeze
    STAGE_KEY = "hint_stage".freeze
    LAST_KEY  = "last_hint".freeze
    def initialize(session, scope: DEFAULT_SCOPE)
      @session = session
      @scope   = scope
      @session[@scope] ||= {}
    end
    def reset!
      write({ STAGE_KEY => 0, LAST_KEY => nil })
    end
    def increment_stage!
      data = read
      data[STAGE_KEY] = data.fetch(STAGE_KEY, 0).to_i + 1
      write(data)
    end
    def stage
      read.fetch(STAGE_KEY, 0).to_i
    end
    def last_hint
      read[LAST_KEY]
    end
    def last_hint=(value)
      data = read
      data[LAST_KEY] = value
      write(data)
    end
    private
    def read
      @session[@scope] ||= {}
    end
    def write(data)
      @session[@scope] = data
    end
  end
end
