class User < ApplicationRecord
  has_secure_password

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }

  # Class method to authenticate with credentials
  def self.authenticate_with_credentials(email, password)
    cleaned_email = email.strip.downcase
    user = User.find_by('LOWER(email) = ?', cleaned_email)

    # Authenticate using has_secure_password
    return user if user && user.authenticate(password)

    nil
  end
end
