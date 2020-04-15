class User < ApplicationRecord
  has_many :consumptions, dependent: :delete_all
  has_many :tags, dependent: :delete_all

  has_secure_password

  has_secure_password :reset_password_token, validations: false

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, on: :update
  validate :reset_password_token_validate, on: :update

  def reset_password_preparation
    update_attribute(:reset_password_token, generate_token)
    update_attribute(:reset_password_sent_at, DateTime.now)
  end

  private

  def generate_token
    SecureRandom.base58(24)
  end

  def reset_password_token_timeout?
    reset_password_sent_at < DateTime.now - 1.hour
  end

  def reset_password_token_validate
    errors.add(:reset_password_token, :timeout) if reset_password_token_timeout?
  end
end
