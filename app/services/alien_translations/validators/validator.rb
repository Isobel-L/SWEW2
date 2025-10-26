module AlienTranslations
  module Validators
    class Validator
      def valid?(_attempt, _solution)
        raise NotImplementedError
      end
    end
  end
end