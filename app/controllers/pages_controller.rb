class PagesController < ApplicationController
  def home
    @account_name = "@AccountName"
    @school_name  = "(School Name)"

    @alien_high_score = nil
    @alien_rank       = nil
    @blast_high_score = nil
    @blast_rank       = nil
    @total_rank       = nil
  end

  def profile
    @account_name = "@AccountName"
    @school_name  = "(School Name)"
  end
end
