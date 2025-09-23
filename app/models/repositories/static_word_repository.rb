module Repositories
  class StaticWordRepository < WordRepository
    def fetch_random
      ["planet", "galaxy", "asteroid", "comet"].sample
    end
  end
end