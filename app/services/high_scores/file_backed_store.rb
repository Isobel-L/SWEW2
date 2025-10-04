require "json"
require "securerandom"
require "fileutils"

module HighScores
  class FileBackedStore
    DIR = Rails.root.join("storage", "high_scores")

    def initialize(session:, cookies: nil)
      @session = session
      @cookies = cookies
      ensure_dir!
    end

    def player_token
      if @cookies
        token = @cookies.signed[:player_token]
        unless token
          token = SecureRandom.hex(12)
          @cookies.permanent.signed[:player_token] = { value: token, httponly: true }
        end
        @session[:player_token] = token
        token
      else
        @session[:player_token] ||= SecureRandom.hex(12)
      end
    end

    def path
      DIR.join("#{player_token}.json")
    end

    def best_score
      data["best_score"]
    end

    def record!(score)
      raise ArgumentError, "score must be Integer" unless score.is_a?(Integer)
      raise ArgumentError, "score must be >= 0" if score.negative?

      if data["best_score"].nil? || score > data["best_score"]
        data["best_score"] = score
        data["updated_at"] = Time.current.iso8601
        persist!
      end

      data["best_score"]
    end

    def info
      data.dup
    end

    private

    def ensure_dir!
      FileUtils.mkdir_p(DIR)
    end

    def data
      @data ||= begin
        if File.exist?(path)
          JSON.parse(File.read(path))
        else
          {}
        end
      rescue JSON::ParserError
        {}
      end
    end

    def persist!
      File.write(path, JSON.pretty_generate(@data))
    end
  end
end
