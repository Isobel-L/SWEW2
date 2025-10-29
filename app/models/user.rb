class User < ApplicationRecord
  has_secure_password

  def total_points
    alien_points + blastoff_points
  end
end
