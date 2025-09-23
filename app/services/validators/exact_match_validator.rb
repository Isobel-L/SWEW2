module Validators
  class ExactMatchValidator < Validator
    def valid?(attempt, solution)
      attempt.to_s.strip.casecmp?(solution.to_s.strip)
    end
  end
end