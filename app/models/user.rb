class User < ApplicationRecord
  has_many :consumptions, dependent: :delete_all
  has_many :tags, dependent: :delete_all

  has_secure_password

  has_secure_password :reset_password_token, validations: false

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :reset_password_validate, on: :update

  def reset_password_preparation
    token = generate_token
    self.reset_password_token = token
    self.reset_password_sent_at = DateTime.now
    save

    token
  end

  private

  def generate_token
    SecureRandom.base58(24)
  end

  def reset_password_token_timeout?
    self.reset_password_sent_at < DateTime.now - 1.hour
  end

  def reset_password_validate
    return if self.reset_password_token.nil?

    if reset_password_token_timeout?
      self.errors.add(:reset_password_token, :timeout)
    end
  end
end
